#!/usr/bin/env python3

import curses
import subprocess

curses.set_escdelay(25)

COMMANDS = {
        "Shutdown": ["systemctl", "poweroff"],
        "Reboot":   ["systemctl", "reboot"],
        "Lock":     ["loginctl", "lock-session"],
        "Logout":   ["hyprctl", "dispatch", "exit"],
        "Suspend":  ["systemctl", "suspend"],
}

def main(stdscr):
    curses.curs_set(0)
    curses.start_color()
    curses.use_default_colors()
    curses.init_pair(1, curses.COLOR_WHITE, -1)
    curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_WHITE)
    curses.init_pair(3, curses.COLOR_BLUE, -1)

    items = list(COMMANDS.keys())
    idx = 0

    max_width = max(len(i) for i in items)

    while True:
        stdscr.clear()
        h, w = stdscr.getmaxyx()

        title = "[ Power Menu ]"
        stdscr.addstr(h // 2 - len(items) // 2 - 2, (w - len(title)) // 2, title, curses.A_BOLD | curses.color_pair(3))

        for i, item in enumerate(items):
            y = h // 2 - len(items) // 2 + i
            label = f"  {item}" + " " * (max_width - len(item) + 2)
            x = w // 4
            attr = curses.color_pair(2) if i == idx else curses.color_pair(1)
            stdscr.addstr(y, x, label, attr)

        stdscr.refresh()
        key = stdscr.getch()

        if key in (ord("q"), 27):
            return
        elif key in (curses.KEY_UP, ord("k")):
            idx = (idx - 1) % len(items)
        elif key in (curses.KEY_DOWN, ord("j")):
            idx = (idx + 1) % len(items)
        elif key in (10, 13, curses.KEY_ENTER):
            subprocess.run(COMMANDS[items[idx]])
            return

if __name__ == "__main__":
    curses.wrapper(main)
