#----------------------------------------------------------------
# Program lab_0a.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_0a.o lab_0a.s
#  To link:    ld -o lab_0a lab_0a.o
#  To run:     ./lab_0a
#
#----------------------------------------------------------------

	.data 			# dyrektywy języka/kompilatora
				# ta oznacza obszar danych

dummy:				# some data
	.byte	0x00		#zmienna o rozmiarze 1 bajta + wartosc poczatkowa
				#dummy to cos jakby nazwa zmiennej, pod warunkiem ze etykietujemy zmienne

	.text			# od tego miejsca kod programu
				# .global i symbol, sporób wskazywania symboli globalnych, widocznych na zewnątrz modułu
	.global _start		# entry point
	
_start:				# etykieta -> faktyczny poczatek programu w tym wypadku. 
	JMP	_start		# globalny, bo linker potrzebuje, najlepiej nazywac start, by default
