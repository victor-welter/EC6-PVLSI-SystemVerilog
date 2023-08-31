module hello_world(
	input logic clock,

	output logic led1,
	output logic led2,
	output logic led3,
	output logic led4
);

	logic [25:0] digit; // 26 bits: 2^26 = 67'108'864
	/* Clock 100 MHz */
	/* 1 / 100'000'000 = _|-| 10 ns */
	/* 10 ns * 67'108'864 =  ns */

	assign led1 = digit[25];
	assign led2 = digit[24];
	assign led3 = digit[23];
	assign led4 = digit[22];

	always_ff @(posedge clock) begin
		digit <= digit + 1'b1;
	end

endmodule
