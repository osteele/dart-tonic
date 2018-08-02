Want to contribute? Great! Please follow this checklist:

* Code must pass analysis by `dartanalyzer --fatal-warnings .`
* Code must be formatted by `dartfmt -w .`
* The test suite must pass ``pub run test`
* New and changed code should be accompanied by test cases.

Check the first three by running `.githooks/pre-push-hook`.

Configure `git` to check this before you push:

`ln -sf ../../.githooks/pre-push-hook .git/hooks`
