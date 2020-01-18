import subprocess
import os
import signal
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-threshold",type=int)
parser.add_argument("-range",type=int)
parser.add_argument("-target",type=int)

args = parser.parse_args()
th = args.threshold

for i in range(args.range):
    print("-------------------------------------")
    print(f"current th = {th}")
    print("-------------------------------------")
    process = subprocess.Popen(
        f'localsolver santa.lsp threshold={th} lsObjectiveThreshold={args.target}',
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        shell=True,
        encoding='utf-8',
        errors='replace'
    )

    while True:
        realtime_output = process.stdout.readline()

        if realtime_output == '' and process.poll() is not None:
            break

        if realtime_output:
            print(realtime_output.strip()+f" th = {th}/{args.threshold}, i = {i}/{args.range} ", flush=True)
            if realtime_output.split(" ")[0].strip() == "occupancy_costs":
                th = int(realtime_output.split(" ")[1].strip())

    process.kill() 

print("-------------------------------------")
print(f"initial threshold = {args.threshold}")
print(f"initial range = {args.range}")
print(f"final threshold = {th}")
print("-------------------------------------")