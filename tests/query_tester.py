import evaluation


import argparse
import os
import pathlib

BASE_PATH = str(pathlib.Path(__file__).absolute().parent.parent.absolute())
DBS_PATH = BASE_PATH + "/tests/run_dbs/"
GT_BASE_PATH = BASE_PATH + "/tests/ground_truth/"
PRE_RUNNER_BASE_PATH = BASE_PATH + "/tests/prerunner/"

NEED_PRE_RUNNER = [10]
DB_DICT = {
    1: ["test1"],
    2: ["test1"],
    3: ["test1"],
    4: ["test1"],
    5: ["test1"],
    6: ["test1"],
    7: ["test1"],
    8: ["test1"],
    9: ["test1"],
    10: ["test1"],
}


def main():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("pos_arg", type=int, help="Query number")
    args = parser.parse_args()
    q_num = args.pos_arg
    q_path = BASE_PATH + f"/Q{q_num}/q{q_num}.sql"
    gt_path = GT_BASE_PATH + f"q{q_num}/"

    if not os.path.isfile(q_path):
        print(f"{q_path} does not exist")
        exit(1)

    query = ""
    with open(q_path, "r") as f:
        query = f.read()

    final_res = True
    for db_path in sorted(pathlib.Path(DBS_PATH).glob("*.db")):

        if db_path.stem not in DB_DICT[q_num]:
            continue

        if q_num in NEED_PRE_RUNNER:
            import sqlite3

            with open(PRE_RUNNER_BASE_PATH + f"/q{q_num}/{db_path.stem}.sql") as f:
                db = sqlite3.connect(str(db_path))
                cursor = db.cursor()
                cursor.executescript(f.read())
                db.commit()
                db.close()

        jsonl_path = gt_path + f"{db_path.stem}.jsonl"
        res = evaluation.evaluate(str(db_path), query, jsonl_path)
        if res:
            print(f"  Test on {db_path.stem} Passed...")
        else:
            print(f"  Test on {db_path.stem} Failed...")

        final_res = final_res and res

    if final_res:
        print("  All query tests passed")
        exit(0)
    else:
        print("  Query tests Failed")
        exit(1)


if __name__ == "__main__":
    main()
