import matplotlib.pyplot as plt
import re
import sys


def main():
    plt.rc("font", size=20)
    plt.style.use("dark_background")
    num = r"[-\d.]+"
    pattern = re.compile(f" 1 = {num} ({num}) {num}")
    y = []
    for line in sys.stdin:
        match = pattern.search(line)
        if match:
            y.append(float(match.group(1)))
    plt.plot(y, ".-", markersize=15)
    plt.xlabel("Time Step")
    plt.tight_layout()
    plt.show()


main()
