///|
test "add - returns the sum" {
  inspect(@project.add(2, 3), content="5")
}
