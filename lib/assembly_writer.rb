AssemblyWriter = Struct.new(:output) do
  def close
    output.close
  end

  def puts(str)
    output.puts(str)
  end

  def push_value(value)
    puts <<-EOF
      @#{value}
      D=A
    EOF

    push_register_d
  end

  def push_value_at(address)
    puts <<-EOF
      @#{address}
      D=M
    EOF

    push_register_d
  end

  def push_register_d
    puts <<-EOF
      // RAM[SP]=D
      @SP
      A=M
      M=D
      // SP++
      @SP
      M=M+1
    EOF
  end

  def pop_register_d
    output.puts <<-EOF
      @SP
      AM=M-1
      D=M
    EOF
  end

  def define_label(label)
    output.puts "(#{label})"
  end

  def jump_to(label)
    output.puts <<-EOF
      @#{label}
      0;JMP
    EOF
  end

  def store(value:, into:)
    puts <<-EOF
      // RAM[#{into}] = #{value}
      @#{value}
      D=A
      @#{into}
      M=D
    EOF
  end

  def copy(from:, to:)
    puts <<-EOF
      // RAM[#{to}] = RAM[#{from}]
      @#{from}
      D=M
      @#{to}
      M=D
    EOF
  end
end
