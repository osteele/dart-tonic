Want to contribute? Great! Please follow this checklist:

1. Code must pass analysis by `dartanalyzer --fatal-warnings .`
2. Code must be formatted by `dartfmt -w .`
3. The test suite must pass ``pub run test`
4. New and changed code should be accompanied by test cases.

Check the first three by running `.githooks/pre-push` from the command line.

Configure git to check (1-3):

```shell
ln -sf ../../.githooks/pre-commit .git/hooks
ln -sf ../../.githooks/pre-push .git/hooks
```
