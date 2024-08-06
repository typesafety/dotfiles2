# dotfiles

Run `./sync.py` from the repository root to snapshot files.  Update
`PATHS_TO_SYNC` to include more files.

Options:

* `--results-dir <PATH>`: Create directory at `<PATH>` to output file/direcotry
  structure.  Defaults to `<script location>/root/`
* `--force`: Delete the results directory if it already exists
  (use with caution).

Typical usage:

```
$ ./sync.py --force
```
