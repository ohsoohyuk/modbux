# model 초기화
model = %{
  1 => %{
    {:hr, 0} => 1,
    {:hr, 1} => 2,
    {:hr, 2} => 3,
    {:hr, 3} => 4,

    {:ir, 0} => 5,
    {:ir, 1} => 6,
    {:ir, 2} => 7,
    {:ir, 3} => 8,

    {:c, 0} => 9,
    {:c, 1} => 10,

    {:i, 0} => 11,
    {:i, 1} => 12
  }
}

{:ok, pid} = Modbux.Model.Shared.start_link(model: model)

IO.puts("=== Input Register Write Test ===")

Modbux.Model.Shared.apply(
  pid,
  {:sir, 1, 0, [17142, 59769]}
)

result =
  Modbux.Model.Shared.apply(
    pid,
    {:rir, 1, 0, 2}
  )

IO.inspect(result, label: "Input Register Read")

IO.puts("")
IO.puts("=== Holding Register Write Test ===")

Modbux.Model.Shared.apply(
  pid,
  {:phr, 1, 0, [17142, 59769]}
)

result =
  Modbux.Model.Shared.apply(
    pid,
    {:rhr, 1, 0, 2}
  )

IO.inspect(result, label: "Holding Register Read")

IO.puts("")
IO.puts("=== Swap Test ===")

{:ok, values} =
  Modbux.Model.Shared.apply(
    pid,
    {:rhr, 1, 0, 2}
  )

[word1, word2] = values

swapped = [word2, word1]

IO.inspect(values, label: "Original")
IO.inspect(swapped, label: "Swapped")

IO.puts("")
IO.puts("=== Float Decode Test ===")

[word1, word2] = values

binary = <<word1::16, word2::16>>

<<float::float-32>> = binary

IO.inspect(float, label: "Float Value")

IO.puts("")
IO.puts("=== Swapped Float Decode Test ===")

[word1, word2] = swapped

binary = <<word1::16, word2::16>>

<<float::float-32>> = binary

IO.inspect(float, label: "Swapped Float Value")
