module fifo(
clk,
reset,
data_in,
write_en,
full,
data_out,
read_en,
empty);


	input reset, clk, write_en, read_en;

	input [27:0] data_in;

	output reg[27:0] data_out;

	output reg full, empty;

	
	reg[3:0] fifo_counter;

	reg[2:0] read_ptr, write_ptr;
	reg[27:0] memory[7:0];

	
	always @(fifo_counter)
	
	begin

			empty = (fifo_counter == 0);

			full = (fifo_counter == 8);
	
	end


	
	always @(posedge clk or posedge reset)
	
	begin

		fifo_counter <= fifo_counter;

		data_out <= data_out;

		read_ptr <= read_ptr;

		write_ptr <= write_ptr;

		if (reset)

		begin

			fifo_counter <= 0;

			data_out <= 0;

			read_ptr <= 0;

			write_ptr <= 0;
		end

		else

		begin

			case ({write_en, read_en})

				2'b01:

				begin

					if (!empty)
					begin

						fifo_counter <= fifo_counter - 1;

						data_out <= memory[read_ptr];

						read_ptr <= read_ptr + 1;

					end

				end

				2'b10:

				begin

					if (!full)

					begin

						fifo_counter <= fifo_counter + 1;

						memory[write_ptr] <= data_in;

						write_ptr <= write_ptr + 1;

					end

				end
				2'b11:
				begin
					if (!full)
					begin
						memory[write_ptr] <= data_in;

						write_ptr <= write_ptr + 1;
					end
					if (!empty)
					begin
						data_out <= memory[read_ptr];

						read_ptr <= read_ptr + 1;
					end
					fifo_counter <= fifo_counter + !full ^ !empty;
				end

			endcase

		end
	end

endmodule
