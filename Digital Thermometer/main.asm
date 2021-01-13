;-------------------------------------------------------------------
; Mencacah 7Seg menggunakan uC sebagai counter 0 mode 0
; Input  : Sensor Suhu -> ADC (P1)
; Output : Multi 7 Segment (P0 dan P3)
;-------------------------------------------------------------------

org 0H
mov p1,#255   	    ; Inisiasi P1 sebagai port input dengan nilai biner 11111111
mov p0,#0   	    ; Inisiasi P0 sebagai port output dengan nilai biner 00000000
mov p3,#0   	    ; Inisiasi P3 sebagai port output dengan nilai biner 00000000
mov dptr,#label     ; Menyiapkan alamat "label" ke dptr

mulai: mov r4,#250  ; Menyalin data 250d ke register R4
      clr p3.7      ; Membuat CS = 0
      setb p3.6     ; Membuat RD = 1
      clr p3.5      ; Membuat WR = 0
      setb p3.5     ; Membuat pulsa rendah menuju pulsa tinggi ke WR untuk memulai konversi

wait: jb p3.4,wait  ; Jalan terus hingga INTR=0
      clr p3.7      ; Membuat CS = 0
      clr p3.6      ; Membuat pulsa tinggi menuju pulsa rendah ke RD untuk membaca data dari ADC
      mov a,p1      ; Memindahkan output digital dari ADC ke accumulator a
      mov b,#10     ; Menyalin data 10d ke b
      div ab        ; Membagi data pada a dengan data pada b
      mov r6,a      ; Memindahkan hasil bagi ke register R6
      mov r7,b      ; Memindahkan sisa bagi ke register R7

ulang:setb p3.2     ; Mengatur P3.2 yang mengaktifkan 7-segment 1
      mov a,r6      ; Memindahkan hasil bagi ke accumulator a
      acall tampil  ; Memanggil subroutine tampil
      mov p0,a      ; Memindahkan data pada a ke P0
      acall tunda   ; Memanggil subroutine tunda
      clr a         ; Menghapus a
      mov a,r7      ; Memindahkan sisa bagi ke a
      clr p3.2      ; Mematikan 7-segment 1
      setb p3.1     ; Menyalakan 7-segment 2
      acall tampil
      mov p0,a      
      acall tunda
      clr a 
      clr p3.1      ; Mematikan 7-segment 2
      djnz r4,ulang ; Mengulang loop "ulang" hingga R4=0
      sjmp mulai    ; Lompat kembali ke loop mulai

tunda: mov r1,#0    ; Menunda

tunggu: djnz r1, tunggu
       ret

label1: djnz r3,label1          
        ret

tampil: movc a, @a+dptr ; Menyalin isi alamat a+dptr ke a
         ret

label: db 3fh ; 0
       db 06h ; 1
       db 5bh ; 2
       db 4fh ; 3
       db 66h ; 4
       db 6dh ; 5
       db 7dh ; 6
       db 07h ; 7
       db 7fh ; 8
       db 6fh ; 9
end
