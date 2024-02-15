# minecheck

Minetest Luacheck

* https://github.com/BuckarooBanzay/luacheck/tree/minetest-builtin
* https://github.com/lunarmodules/luacheck/pull/108

```yaml
name: minecheck
on: [push, pull_request]
jobs:
  minecheck:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: S-S-X/minecheck@master
```