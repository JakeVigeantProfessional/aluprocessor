module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] addRes, andRes, orRes, sllRes, sraRes, subRes;
    wire doSub;
    wire [31:0] inputB;
    //addition/subtraction result
    //cla_full_adder(x, y, c_in, p, g, s);
    //use cin to add on 1 if subtraction
    
    //adder cla_full_adder(data_operandA, data_operandB, doSu4b, p, g, addResult);
    cla_full_adder aluAdder(data_operandA, inputB, ctrl_ALUopcode[0], addRes);

    //subtraction result
    //invert input b
    //module mux_2(out, select, in0, in1);
    wire [31:0] inverted_B;
    bit_inverter aluInv(data_operandB, inverted_B);


    mux_2 chooseSubt(inputB, ctrl_ALUopcode[0], data_operandB, inverted_B);

    //and result
    bitwise_and aluAnd(data_operandA, data_operandB, andRes);


    //or result
    bitwise_or aluOR(data_operandA, data_operandB, orRes);

    //sll result
    //module left_barrel_shifter (data, amt, out);
    left_barrel_shifter aluLeft(data_operandA,ctrl_shiftamt,sllRes);

    //sra result
    right_barrel_shifter aluRight(data_operandA,ctrl_shiftamt,sraRes);

    // use 8 bit mux to select output based on opcode
    //mux_8(in0,in1,in2,in3,in4,in5,in6,in7, out, select);
    mux_8 resultSelection(addRes, addRes, andRes, orRes, sllRes, sraRes, 32'b0, 32'b0, data_result, ctrl_ALUopcode[2:0]);

    // positive overflow
    wire positive_ovf;
    //Both inputs are positive and final sum bit is 1
    and posOvf(positive_ovf, data_operandA[31] ? 0:1, data_operandB[31] ? 0:1, addRes[31]);
    wire negative_overflow;
    and negOvf(negative_overflow, data_operandA[31], data_operandB[31], addRes[31] ? 0 : 1);


    or ovfTot(overflow, positive_ovf, negative_overflow);

    //Not Equal
    or isNeq(isNotEqual, addRes[0], addRes[1], addRes[2], addRes[3], addRes[4], addRes[5], addRes[6], addRes[7], addRes[8], addRes[9], addRes[10], addRes[11], addRes[12], addRes[13], addRes[14], addRes[15], addRes[16], addRes[17], addRes[18], addRes[19], addRes[20], addRes[21], addRes[22], addRes[23], addRes[24], addRes[25], addRes[26], addRes[27], addRes[28], addRes[29], addRes[30], addRes[31]);

    // is less than
    // check if MSB of sum is a 1 (sum is negative) AND no pos overflow
    // or if MSB of sum is 0 (sum is positive) AND neg overflow occurred (special case)
    wire normal_check_less_than, special_check_less_than;
    and check_normal_less_than(normal_check_less_than, addRes[31], positive_ovf ? 0 : 1);
    and check_special_less_than(special_check_less_than, addRes[31] ? 0 : 1, negative_overflow);
    or check_less_than(isLessThan, normal_check_less_than, special_check_less_than);
endmodule