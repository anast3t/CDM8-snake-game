asect 0xFF
	IOReg:
#TODO
#1 - отрисовка головы
#2 - стирание хвоста
#3 - выход за стенки
#4 - Передача направления
asect 0x00
start:
setsp 0xFE
#начальное положение змейки на поле
tst r2
tst r3
#ловим PC и меняем RAM
#пишем в память для дисплея
ldi r0, 1
ldi r1, 0xF0
st r1, r0
inc r1
st r1, r0
inc r1
st r1, r0
#ловим PC и меняем RAM
#пишем в память для данных
tst r3
tst r2
# строка/столбец для головы и хвоста
ldi r0, 0xA0 #0xA0 - headPOS
st r0, r1
inc r0 #0xA1 - TailPOS
ldi r1, 0xF0
st r0, r1

inc r0 #0xA2 - HeadBuffAddr
ldi r1, 0xB2
st r0, r1
inc r0 #0xA3 - TailBuffAddr
ldi r1, 0xB0
st r0, r1

ldi r1, 0
push r1
readkeyboard:
do
pop r1
#r1 - направление головы
if
tst r1
is eq
then
	#получаем headPOS
	ldi r0, 0xA0
	ld r0, r2
	#сдвигаем вправо
	inc r2
	st r0, r2
	#рисуем новую голову
	jsr forhead
else
	if
	ldi r0, 1
	cmp r1, r0
	is eq
	then
		#получаем headPOS
		ldi r0, 0xA0
		ld r0, r2
		#сдвигаем влево
		dec r2
		st r0, r2
		#рисуем новую голову
		jsr forhead
	else
		if
		ldi r0, 2
		cmp r1, r0
		is eq
		then
			#получаем headPOS
			ldi r0, 0xA0
			ld r0, r2
			#сдвигаем вверх
			ldi r3, 16
			sub r2, r3
			st r0, r3
			#рисуем новую голову
			jsr forhead
		else
			if
			ldi r0, 2
			cmp r1, r0
			is eq
			then
				#получаем headPOS
				ldi r0, 0xA0
				ld r0, r2
				#сдвигаем вниз
				ldi r3, 16
				add r3, r2
				st r0, r2
				#рисуем новую голову
				jsr forhead
			fi
		fi
	fi
fi
#сохранили в буфер, куда сходила голова
ldi r0, 0xA2
ld r0, r0
st r0 ,r1


#сдвиг головы в буфере
ldi r1, 0xA2
jsr cycle

#дальше стираем хвост

ldi r0, IOReg
ld r0, r0
tst r0
until pl
push r0


br readkeyboard

forhead:
	#r1 - направление головы
	#0xA0 - headPos
	ldi r0, 0xA0
	ld r0, r0
	tst r2
	tst r3
	#ловим PC и меняем RAM
	#пишем в память для дисплея
	ldi r2, 1
	st r0, r2
	#ловим PC и меняем RAM
	#вернемся на память для данных
	tst r3
	tst r2
rts

cycle:
	#r0 - buffPos
	#r1 - куда сохранять позицию в буфере
	#проверим, не вышли ли за пределы буфера
	ldi r2, 0xBF
	inc r0
	if
	cmp r0, r2
	is gt
	then
		ldi r0, 0xB0 #закольцевали,если нужно
	fi
	st r1, r0
rts
halt
end.