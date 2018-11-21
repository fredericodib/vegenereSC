$tam_texto
$tam_kay = 0
$criptograma = []
$coincidencia = []
$simb_mais_freq = []
$colunas_de_simbolos = [[]]
$letras_freq = [32, 97, 101, 111, 115, 114, 100, 105, 109, 116, 117, 110, 112, 99, 103]
$pre_chave = []
$chave = []


def montar_array_de_criptogramas()
  file = File.open("input.txt", "r").read
  file.gsub!(/\r\n?/, "\n")
  lines = []
  file.each_line.with_index do |line, index|
    lines << line
  end
  
  $tam_texto = lines[lines.size-1].to_i

  lines.each.with_index do |line, index|
    $criptograma << line if (index > 1 && index < $tam_texto+2)
  end

  $criptograma.map { |a| a.delete!("\n").to_i }
end

def print_criptograma() 
  puts "Criptograma:"
  puts $criptograma.join(' ')
end

def encontra_coincidencia()
  for index in 1...$tam_texto
    count = 0
    for i in 0...$tam_texto-index
      count = count + 1 if ($criptograma[index+i] == $criptograma[i])
    end
    $coincidencia << count
  end
end

def print_coincidencias()
  puts "\n\nVetor de coincidencias"
  puts $coincidencia.join(' ')
end

def find_key_length()
  media = 0


  for i in 0...($tam_texto/3)
    media = media + $coincidencia[i]
  end
  media = media/($coincidencia.size/3)

  n_chaves = 1
  anormalidade = 0
  for i in 0...($tam_texto/3)
    anormalidade = anormalidade + 1
    if ($coincidencia[i] > 2*media)
      $tam_kay = anormalidade if $tam_kay == 0
      $tam_kay = ($tam_kay * n_chaves + anormalidade)/(n_chaves+1) if $tam_kay != 0
      n_chaves = n_chaves + 1
      anormalidade = 0
    end
  end

  $tam_kay = $tam_kay.round
  puts "\n\nO Tamanho provavel da chave é #{$tam_kay}"
end

def group_numbers
  for i in 0...$tam_kay-1
    $colunas_de_simbolos << []
  end
  $criptograma.each_slice($tam_kay) do |slice|
    slice.each.with_index do |c, i|
      $colunas_de_simbolos[i] << c
    end
  end

  
  $colunas_de_simbolos.each.with_index do |array, index|
    hash = {}
    array.each do |key| 
      hash[key] = hash[key] + 1 if hash[key]
      hash[key] = 0 unless hash[key]
    end
    frequent_key = 0
    frequent_value = 0
    hash.each do |key, value| 
      frequent_key = key if value > frequent_value
      frequent_value = value if value > frequent_value
    end
    $simb_mais_freq << frequent_key
    puts "\n\nColuna #{index+1}, o caractere mais frequente é #{frequent_key}, apareceu #{frequent_value} vezes!"
  end
end

def set_pre_chave
  for i in 0...$tam_kay
    $pre_chave << 0
    $chave << 0
  end
end

def calculate_key
  for i in 0...$tam_kay
    key = $letras_freq[$pre_chave[i]].to_i ^ $simb_mais_freq[i].to_i
    $chave[i] = key
  end
end

def print_key
  puts "\nChave pré encontrada:\n"
  for i in 0...$tam_kay
    print  "#{$chave[i]} "
  end
  puts "\n\n"
end

def print_msg
  puts "\n\n#################### Mensagem ####################\n\n"
  for i in 0...$tam_kay
    print i+1
  end
  print "\n"

  $criptograma.each_slice($tam_kay) do |slice|
    slice.each.with_index do |c, i|
      print (c.to_i ^ $chave[i].to_i).chr
    end
  end
  puts "\n\n#################### FIM ####################\n\n"
  puts "A mensagem ta pré pronta"
  puts "Sabendo que a chave mede #{$tam_kay}, digite o numero da coluna que está incorreta para tentar uma nova combinação"
  puts "Se estiver tudo ok digite -1"
  puts "Lembrando que o terminal não mostra acento"

end

def change_key(value)
  $pre_chave[value] = $pre_chave[value] + 1
end

def print_output
  f = File.new('output.txt', 'w')
  $criptograma.each_slice($tam_kay) do |slice|
    slice.each.with_index do |c, i|
      f.write (c.to_i ^ $chave[i].to_i).chr
    end
  end
end

def main()
  input=0

  montar_array_de_criptogramas()
  print_criptograma()
  encontra_coincidencia()
  print_coincidencias()
  find_key_length()
  group_numbers()
  set_pre_chave()

  begin
  calculate_key()
  print_key()
  print_msg()
  input = gets()
  change_key(input.to_i-1) if input.to_i > 0
  end while input.to_i > 0
  print_output()
  puts "Muito bem, espero ter ajudado, a mensagem está salva no output\n"

end

main()
