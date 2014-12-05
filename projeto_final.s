.data

agenda: .space 4000
busca: .space 12

msgopcoes: .asciiz "\nBem Vindo a AgendaMips.\n\n1 - Incluir Contato.\n2 - Excluir Contato.\n3 - Buscar Contato.\n4 - Exibir Agenda.\n5 - Sair da agenda.\n\n"		
msgerro1: .asciiz "\nERRO 1 : Opcao Invalida.\n\n"
msgerro2: .asciiz "\nERRO 2 : Telefone nao encontrado.\n\n"
msgerro3: .asciiz "\nERRO 3 : Agenda vazia.\n\n"
msgnome: .asciiz "\nNome : "
msgtelefone: .asciiz "Telefone : "
msgtelexcluir: .asciiz "\nDigite o telefone para deletar contato da agenda: "
msgtelbusca: .asciiz "\nDigite o telefone para pesquisa na agenda: "
msgsucessoexcluir: .asciiz "\nContato excluido com sucesso.\n"
msgfim: .asciiz "FIM"
msgmostrar: .asciiz "---------------------------------------\n"

.text				    # indica que as linhas seguintes contém instruções
.globl comeca			# define o símbolo main como sendo global

comeca:

	add $s0, $zero, $zero	# Limpa o conteúdo de $s0 
	add $s1, $zero, $zero	# Limpa o conteúdo de $s1

main:
	add $t0, $zero, $zero	# Limpa o conteúdo de $t0
	add $t1, $zero, $zero	# Limpa o conteúdo de $t1
	add $t2, $zero, $zero   # Limpa o conteúdo de $t2
	add $t3, $zero, $zero	# Limpa o conteúdo de $t3
	add $t4, $zero, $zero	# Limpa o conteúdo de $t4
	add $t5, $zero, $zero	# Limpa o conteúdo de $t5
	add $t6, $zero, $zero	# Limpa o conteúdo de $t6
	add $t7, $zero, $zero	# Limpa o conteúdo de $t7
	add $t8, $zero, $zero	# Limpa o conteúdo de $t8
	add $t9, $zero, $zero	# Limpa o conteúdo de $t9
	
	li $v0, 4		    # codigo syscall para escrita de strings
	la $a0, msgopcoes	# Parametro (string a ser escrita)
	syscall

	li $v0, 5           # Codigo SysCall p/ ler inteiros
	syscall             # Inteiro lido vai ficar em $v0
	
	li $t0,1            # Se opcao igual 1
	beq $v0,$t0,incluir	# Ir para label incluir

	li $t0,2            # Se opcao igual 2
	beq $v0,$t0,excluir	# Ir para label excluir

	li $t0,3            # Se opcao igual 3
	beq $v0,$t0,buscar	# Ir para label buscar

	li $t0,4            # Se opcao igual 4
	beq $v0,$t0,exibir	# Ir para label exibir

	li $t0,5            # Se opcao igual 5
	beq $v0,$t0,fim		# Ir para label fim
		
	j erro1             # Se 0<x>6 erro1

#----------------------------------//Incluir\\-----------------------------------

incluir:
	
	mul $s1, $s2, 40	# Cada inclusao multiplica $s2 por 40 e guarda em $s1
	
	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, msgnome 	# Parametro (string a ser escrita) 
	syscall 
	
	li $v0, 8           # Ler string no buffer de endereço $a0
	la $a0, agenda		# Gravar $a0 em agenda
	add $a0, $a0, $s1	# 
	li $a1, 28          # Gravar em 28 bytes
	syscall
	
	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, msgtelefone	# Parametro (string a ser escrita) 
	syscall 
		
	add $t2,$t2,$s1		# 
	addi $t2,$t2,28		# Adiciona 28 ao valor de t2

	li $v0, 8           # Ler string no buffer de endereço $a0
	la $a0, agenda		# Gravar $a0 em agenda
	add $a0, $a0, $t2	
	li $a1, 12          # Gravar em 12 bytes
	syscall

	addi $s2, $s2, 1	# Cada inclusão adiciona 1 em $s2

	j main

#----------------------------------//Excluir\\-----------------------------------

excluir:
	
	beq $s2,$zero,erro3	#Teste agenda vazia
	
	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, msgtelexcluir	# Parametro (string a ser escrita) 
	syscall 

	li $v0, 8           # Ler string no buffer de endereço $a0
	la $a0, busca
	add $a0, $a0, $zero
	li $a1, 12
	syscall

	lw $t1, busca($zero)


loopbuscaexcluir:

	add $t2, $zero, $zero 	# limpa o conteúdo de $t2
	add $t3,$zero, $zero	# limpa o conteúdo de $t3

	mul $t4, $t9, 40
	
	addi $t4,$t4,28

	lw $t2, agenda($t4)
	beq $t1, $t2, sucessobuscaexcluir

	addi $t9, $t9, 1
	slt $t3, $t9, $s2
	bne $t3, $zero, loopbuscaexcluir

	li $v0, 4           	# codigo syscall para escrita de strings 
	la $a0, msgerro2 	# Parametro (string a ser escrita) 
	syscall
	
  j main

sucessobuscaexcluir:
	
	sw $zero, agenda($t4)

	addi $t4,$t4,-28
	sw $zero, agenda($t4)


	li $v0, 4                   # codigo syscall para escrita de strings 
	la $a0, msgsucessoexcluir	# Parametro (string a ser escrita) 
	syscall 

  j main

#----------------------------------//Buscar\\-----------------------------------

buscar:

	beq $s2,$zero,erro3	#Teste agenda vazia
	li $v0, 4               # codigo syscall para escrita de strings 
	la $a0, msgtelbusca	# Parametro (string a ser escrita) 
	syscall 

	li $v0, 8           # Ler string no buffer de endereço $a0
	la $a0, busca
	add $a0, $a0, $zero
	li $a1, 12
	syscall

	lw $t1, busca($zero)
	
loopbusca:

	add $t2, $zero, $zero 	# limpa o conteúdo de $t2
	add $t3,$zero, $zero	# limpa o conteúdo de $t3

	mul $t7, $t9, 40
	
	addi $t7,$t7,28

	lw $t2, agenda($t7)
	beq $t1, $t2, sucessobusca
	addi $t9, $t9, 1
	slt $t3, $t9, $s2
	bne $t3, $zero, loopbusca

	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, msgerro2 	# Parametro (string a ser escrita) 
	syscall
	
  j main

sucessobusca:

	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, msgmostrar	# Parametro (string a ser escrita) 
	syscall

	addi $t7,$t7,-28
	
	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, agenda		# Parametro (string a ser escrita)
	add $a0, $a0, $t7
	syscall
	
	li $v0, 4           # codigo syscall para escrita de inteiros 
	la $a0, agenda		# Parametro (inteiro a ser escrito)
	addi $t7,$t7,28
	add $a0,$a0,$t7
	syscall
	
	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, msgmostrar	# Parametro (string a ser escrita) 
	syscall

  j main

#----------------------------------//Exibir\\-----------------------------------

exibir:

	beq $s2,$zero,erro3	# Teste agenda vazia
	
	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, msgmostrar	# Parametro (string a ser escrita) 
	syscall
	
	mul $t2, $t9, 40	

	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, agenda  	# Parametro (string a ser escrita)
	add $a0, $a0, $t2
	syscall
	
	add $t3,$t3,$t2
	addi $t3,$t3,28

	li $v0, 4           # codigo syscall para escrita de inteiros 
	la $a0, agenda	 	# Parametro (inteiro a ser escrito)
	add $a0, $a0, $t3
	syscall 
	
	add $t3,$zero,$zero

	addi $t9, $t9, 1
	slt $t1, $t9, $s2
	bne $t1, $zero, exibir


	li $v0, 4           # codigo syscall para escrita de strings 
	la $a0, msgmostrar	# Parametro (string a ser escrita) 
	syscall
	
  j main
	
#----------------------------------//Fim\\-----------------------------------

fim:
	li $v0, 4           # codigo syscall para escrita de strings
	la $a0, msgfim		# Parametro (string a ser escrita)
	syscall
	
	li $v0,10           # Codigo SysCall p/ terminar programa
	syscall

#----------------------------------//Erros\\----------------------------------

erro1:
	li $v0, 4           # codigo syscall para escrita de strings
	la $a0, msgerro1	# Parametro (string a ser escrita)
	syscall
	
  j main

erro2:
	li $v0, 4           # codigo syscall para escrita de strings
	la $a0, msgerro2	# Parametro (string a ser escrita)
	syscall
	
  j main

erro3:
	li $v0, 4           # codigo syscall para escrita de strings
	la $a0, msgerro3	# Parametro (string a ser escrita)
	syscall
	
  j main
