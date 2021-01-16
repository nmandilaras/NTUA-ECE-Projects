void foo(x, byref y) {
  begin
    let z = x + y
    let y = z + 42
  end
}

void main() {
  begin
    let x = 1
    let y = 2
    foo (x, y)
    print y
  end
}
