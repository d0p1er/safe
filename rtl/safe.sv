`timescale 1ns/1ns

typedef enum logic [2:0] {
    KEY_0_           = 3'h0,
    KEY_1_           = 3'h1,
    KEY_2_           = 3'h2,
    KEY_3_           = 3'h3,
    KEY_OK_          = 3'h4,
    KEY_CLEAR_       = 3'h5,
    DOOR_SEALED_     = 3'h6
} data_in;

typedef enum logic [2:0] {
    LOCKED          = 3'd0,
    CODE_CHECK      = 3'd1,
    OPEN            = 3'd2
} safe_state;

typedef enum logic [2:0] {
    IN_LOCK         = 3'h0,
    IN_CHECK        = 3'h1,
    IN_OPEN         = 3'h2,
    PASS_OK         = 3'h3,
    PASS_FAIL       = 3'h4,
    TIMEOUT         = 3'h5,
    CLOSE           = 3'h6
} data_out;

module safe
#(
    parameter CODE_LENGTH = 2,
    // parameter WRONG_ATTEMPS = 3,
    parameter TIMEOUT_VALUE = 1000
)
(
    input 
            logic       clk_i,
            logic       arst_n_i,
            logic       KEY_0,
            logic       KEY_1,
            logic       KEY_2,
            logic       KEY_3,
            logic       KEY_OK,
            logic       KEY_CLEAR,
            logic       DOOR_SEALED,

    output
            data_out    data_out_o,
            logic       data_out_valid_o,
            logic       a,
            logic       b,
            logic       c,
            logic       d,
            logic       e,
            logic       f,
            logic       g
);

typedef logic [CODE_LENGTH-1:0][2:0] code_reg;

code_reg current_input, current_pass;
initial begin
    current_pass[1] <= 3'h1;
    current_pass[0] <= 3'h2;
end

data_in data_prev;

logic [$clog2(CODE_LENGTH):0] current_input_cnt = 1'b0;

logic [$clog2(TIMEOUT_VALUE):0] timeout_cnt;

safe_state state;


logic data_in_handshake;
logic data_out_handshake;

assign data_in_handshake    = arst_n_i;
assign data_out_handshake   = data_out_valid_o;

// Input type

logic is_digit_input;
logic is_submit;
logic is_clear;
logic is_sealed;

assign is_digit_input       = data_in_handshake & (KEY_0 |  KEY_1 | KEY_2 | KEY_3);
assign is_submit            = data_in_handshake & (KEY_OK);
assign is_clear             = data_in_handshake & (KEY_CLEAR);
assign is_sealed            = data_in_handshake & (DOOR_SEALED);

// Code input management

logic digit_input_allowed;
logic code_input_allowed;
logic clear_current_input;

logic code_match;

// logic [$clog2(WRONG_ATTEMPS-1):0] wrong_attemps;
// logic about_to_block;
// logic wrong_code_attempted;

assign digit_input_allowed  = (state == LOCKED) | (state == CODE_CHECK);
assign code_input_allowed   = is_digit_input & (current_input_cnt < CODE_LENGTH);
assign clear_current_input  = is_submit & (state == OPEN | state == CODE_CHECK) | is_clear;
assign code_match           = current_input == current_pass;

// assign about_to_block       = wrong_attemps == WRONG_ATTEMPS - 1;
// assign wrong_code_attempted = (is_submit) & ~code_match & (wrong_attemps < WRONG_ATTEMPS);

logic timeout;
logic timeout_active;

assign timeout              = timeout_cnt == TIMEOUT_VALUE;
assign timeout_active       = state == CODE_CHECK;


/* States logic */

always_ff @(posedge clk_i or negedge arst_n_i) begin
    if(~arst_n_i) begin
        state <= LOCKED;
    end
    else begin
        case(state)
            LOCKED:
                if(is_digit_input) begin
                    state <= CODE_CHECK;
                end
            CODE_CHECK:
                if(timeout) begin
                    state <= LOCKED;
                end
                else if(is_submit) begin
                    if(code_match)
                        state <= OPEN;
                    else begin
                        state <= LOCKED;
                    end
                end
            OPEN:
                if(is_sealed) begin
                    state <= LOCKED;
                end
            default:
                state <= LOCKED;
        endcase
    end
end


/* Timeout logic */

always_ff @(posedge clk_i or negedge arst_n_i) begin
    if(~arst_n_i)
        timeout_cnt <= 0;
    else begin
        if(timeout_active) begin
            if(timeout)
                timeout_cnt <= 0;
            else timeout_cnt <= timeout_cnt + 1'b1;
        end
        else timeout_cnt <= 0;
    end
end


/* Input logic */

always_ff @(posedge clk_i or negedge arst_n_i) begin
    if(~arst_n_i) begin
        current_input_cnt <= 0;
        current_input <= 0;
    end
    else begin
        if(digit_input_allowed) begin
            if(clear_current_input | timeout) begin
                current_input_cnt = 0;
                current_input = '0;

                if(KEY_OK) begin
                    data_prev <= KEY_OK_;
                end
                else if(KEY_CLEAR) begin
                    data_prev <= KEY_CLEAR_;
                end
            end
            else if(code_input_allowed & ~current_input_cnt) begin
                if(KEY_0) begin
                    current_input[current_input_cnt] <= 3'h0;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= KEY_0_;
                end
                else if(KEY_1) begin
                    current_input[current_input_cnt] <= 3'h1;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= KEY_1_;
                end
                else if(KEY_2) begin
                    current_input[current_input_cnt] <= 3'h2;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= KEY_2_;
                end
                else if(KEY_3) begin
                    current_input[current_input_cnt] <= 3'h3;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= KEY_3_;
                end
                else if(DOOR_SEALED) begin
                    current_input[current_input_cnt] <= 3'h6;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= DOOR_SEALED_;
                end
            end
            else if(code_input_allowed) begin
                if(KEY_0 & data_prev != KEY_0_) begin
                    current_input[current_input_cnt] <= 3'h0;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= KEY_0_;
                end
                else if(KEY_1 & data_prev != KEY_1_) begin
                    current_input[current_input_cnt] <= 3'h1;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= KEY_1_;
                end
                else if(KEY_2 & data_prev != KEY_2_) begin
                    current_input[current_input_cnt] <= 3'h2;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= KEY_2_;
                end
                else if(KEY_3 & data_prev != KEY_3_) begin
                    current_input[current_input_cnt] <= 3'h3;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= KEY_3_;
                end
                else if(DOOR_SEALED & data_prev != DOOR_SEALED_) begin
                    current_input[current_input_cnt] <= 3'h6;
                    current_input_cnt <= current_input_cnt + 1'b1;
                    data_prev <= DOOR_SEALED_;
                end
            end
        end
    end
end

/* Wrong attempts logic */

// always_ff @(posedge clk_i or negedge arst_n_i) begin
//     if(~arst_n_i) begin
//         wrong_attemps <= 0;
//     end
//     else begin
//         if(state == CODE_CHECK) begin
//             if(wrong_code_attempted)
//                 wrong_attemps <= wrong_attemps + 1'b1;
//         end
//         else wrong_attemps <= 0;
//     end
// end

/* Output logic */

always_comb begin
    if(~arst_n_i) begin
        data_out_o = IN_LOCK;
        data_out_valid_o = 1'b1;
    end
    else begin
        case(state)
            LOCKED:
                if(is_digit_input) begin
                    data_out_o = IN_CHECK;
                    data_out_valid_o = 1'b1;
                end
                // else begin
                //     data_out_o = IN_LOCK;
                //     data_out_valid_o = 1'b1;
                // end
            CODE_CHECK:
                if(timeout) begin
                    data_out_o = TIMEOUT;
                    data_out_valid_o = 1'b1;
                end 
                else if(is_submit) begin
                    if(code_match) begin
                        data_out_o = PASS_OK;
                        data_out_valid_o = 1'b1;
                    end
                    else if(data_out_o != PASS_OK) begin
                        data_out_o = PASS_FAIL;
                        data_out_valid_o = 1'b1;
                    end       
                end
                // else begin
                //     data_out_o = IN_CHECK;
                //     data_out_valid_o = 1'b1;
                // end
            OPEN:
                if(is_sealed) begin
                    data_out_o = CLOSE;
                    data_out_valid_o = 1'b1;
                end
                // else begin
                //     data_out_o = IN_OPEN;
                //     data_out_valid_o = 1'b1;
                // end
        endcase
    end
end

/* Output indicator logic */
/* Indicator with low level */
always_comb begin
    if(~arst_n_i) begin
        a = 1'b1;
        b = 1'b1;
        c = 1'b1;
        d = 1'b1;
        e = 1'b1;
        f = 1'b1;
        g = 1'b1;
    end
    else begin
        case(data_out_o)
            IN_CHECK: begin
                a = 1'b1;
                b = 1'b0;
                c = 1'b0;
                d = 1'b1;
                e = 1'b1;
                f = 1'b1;
                g = 1'b1;
            end
            PASS_OK: begin
                a = 1'b0;
                b = 1'b0;
                c = 1'b0;
                d = 1'b0;
                e = 1'b0;
                f = 1'b0;
                g = 1'b1;
            end
            PASS_FAIL: begin
                a = 1'b0;
                b = 1'b1;
                c = 1'b1;
                d = 1'b1;
                e = 1'b0;
                f = 1'b0;
                g = 1'b0;
            end
            TIMEOUT: begin
                a = 1'b1;
                b = 1'b0;
                c = 1'b0;
                d = 1'b1;
                e = 1'b1;
                f = 1'b1;
                g = 1'b0;
            end
            CLOSE: begin
                a = 1'b0;
                b = 1'b1;
                c = 1'b1;
                d = 1'b0;
                e = 1'b0;
                f = 1'b0;
                g = 1'b1;
            end
        endcase
    end
end

endmodule