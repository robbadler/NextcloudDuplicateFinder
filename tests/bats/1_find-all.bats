#!/usr/bin/env bats
TESTSUITE="duplicatefinder"
load ${BATS_TEST_DIRNAME}/helper.sh

setup() {
  load ${BATS_TEST_DIRNAME}/setup.sh
}

@test "[$TESTSUITE] Scan duplicates for user" {
  run ./occ -v duplicates:find-all -u admin
  [ "$status" -eq 0 ]

  expectedHash="6d833d062a1d903fdc9b88f513017f9d02d8808d4824ee24243f9d3cd982d23a"
  evaluateHashResult "${expectedHash}" 25 "${output}"
}

@test "[$TESTSUITE] Scan duplicates for path" {
  run ./occ -v duplicates:find-all -p ./tests
  [ "$status" -eq 0 ]

  expectedHash="68a757b39206d7417aa06323731207c2da06dd968163efc7f46df7e814605263"
  # 51 because tuser hash file "zero" two times
  evaluateHashResult "${expectedHash}" 50 "${output}"
}

@test "[$TESTSUITE] Scan duplicates for user and path" {
  run ./occ -v duplicates:find-all -u tuser -p tests2
  [ "$status" -eq 0 ]

  expectedHash="9d057f8673fbb54276dc31ca27d7da7b6a5cdf0d4d532dfd3ed7b14536e425fc"
  evaluateHashResult "${expectedHash}" 26 "${output}"
}

@test "[$TESTSUITE] Scan for all duplicates" {
  run ./occ -v duplicates:find-all
  [ "$status" -eq 0 ]

  expectedHash="21ff9ac67ce5bff4ca41e4b2be97d821fd498103e55ee1a91be40ec90de3a436"
  evaluateHashResult "${expectedHash}" 51 "${output}"
}

@test "[$TESTSUITE] Scan path that doesn't exist" {
  run ./occ -v duplicates:find-all -p path_not_found
  [ "$status" -eq 0 ]

  expectedHash="1b278ef83c75029169468ea7ece822eb73e81575cffe0c15253c518efc75f7ce"
  evaluateHashResult "${expectedHash}" 51 "${output}"
}

@test "[$TESTSUITE] Check for user separation" {
  run ./occ -v duplicates:find-all -u tuser
  [ "$status" -eq 0 ]

  if [[ $(echo "$output" | grep "admin" | wc -l ) -ne 0 ]]; then
    echo "Output is other than expected:"
    echo "$output"
    return 1
  fi
}
