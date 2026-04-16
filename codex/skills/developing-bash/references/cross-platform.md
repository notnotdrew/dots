# Cross-Platform Shell

Use this reference when a script must behave the same on macOS and Linux.

## Assume Differences In

- `sed -i`
- `date`
- `stat`
- `readlink`
- `find`
- `xargs` and other utility flags

## Preferred Approach

1. Prefer flags that already work on both platforms.
2. If that is not possible, isolate the difference in one helper.
3. Avoid scattering `uname` branches across the script.

## Typical Differences

```bash
case "$(uname -s)" in
    Darwin) os="macos" ;;
    Linux)  os="linux" ;;
    *)      os="other" ;;
esac
```

- `sed -i`: GNU accepts `-i`; BSD often needs `-i ''`
- `date`: GNU commonly uses `-d`; BSD uses `-j` and `-f` or `-v`
- `stat`: GNU uses `-c`; BSD uses `-f`
- `readlink -f`: common on GNU, absent on stock macOS

## Practical Rule

If a command feels OS-specific, test it before baking it into a shared script. Small wrappers are cheaper than debugging hidden GNU assumptions later.
