"
no comment
"
Class {
	#name : #AoC2018Day21,
	#superclass : #AoC2018DayWithVM,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day21 >> run: filename [

	self initializeFromInput: filename.
	^ self solvePartOne
]

{ #category : #running }
AoC2018Day21 >> solvePartOne [

	state := AoCState fromNumbers: #( 7967233 0 0 0 0 0 ).
	[ instructionCount < 100000 and: [ self isHalted not ] ] whileTrue: [
		self step ].
	"self debug"
	^ 7967233
	"7967233: value of register 3 when line 28 is reached. Observable by adding the following condition:"
	" `and: [ (state at: ipReg) ~= 28 ]`"

	"0   # 123 -> @3                 ~"
	"1   # @3 & 456 -> @3            ~"
	"2   # (@3 == 72) ? 1 : 0 -> @3  ~ if @3 == 72:"
	"3   # @3 + @2 -> @2             ~   GOTO 5"
	"4   # 0 -> @2                   ~ else: GOTO 1"
	""
	"5   # 0 -> @3                   # @3 = 0"
	""
	"6   # @3 | 65536 -> @1          . @1 = @3 | 65536"
	"7   # 10373714 -> @3            # @3 = 10373714"
	"8   # @1 & 255 -> @5            . @5 = @1 & 255 (@1 mod 2^8)"
	"9   # @3 + @5 -> @3             # @3 += @5"
	"10  # @3 & 16777215 -> @3       # @3 &= 2^24-1 (mod 2^24)"
	"11  # @3 * 65899 -> @3          # @3 *= 65899"
	"12  # @3 & 16777215 -> @3       # @3 &= 2^24-1 (mod 2^24)"
	"13  # (256 > @1) ? 1 : 0 -> @5  # if @1 < 256:"
	"14  # @5 + @2 -> @2             #   GOTO 16 (=> GOTO 28)"
	"15  # @2 + 1 -> @2              # else: GOTO 17 (continue)"
	"16  # 27 -> @2                  # GOTO 28"
	"17  # 0 -> @5                   # @5 = 0"
	"18  # @5 + 1 -> @4              . @4 = @5 + 1"
	"19  # @4 * 256 -> @4            # @4 *= 256"
	"20  # (@4 > @1) ? 1 : 0 -> @4   # if @4 > @1:"
	"21  # @4 + @2 -> @2             #   GOTO 23 (=> GOTO 26: set @1 to @5 and goto 8)"
	"22  # @2 + 1 -> @2              # else: GOTO 24 (increment @5 and goto 18)"
	""
	"23  # 25 -> @2                  . GOTO 26"
	"24  # @5 + 1 -> @5              . @5 += 1"
	"25  # 17 -> @2                  # GOTO 18"
	"26  # @5 -> @1                  . @1 = @5"
	"27  # 7 -> @2                   # GOTO 8"
	""
	"28  # (@3 == @0) ? 1 : 0 -> @5  . if @3 == @0:"
	"29  # @5 + @2 -> @2             #   HALT"
	"30  # 5 -> @2                   # else: GOTO 6"
]
