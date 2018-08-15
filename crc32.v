/* CRC check module 
test1

standard        generator polynomial                           HEX      
CRC12           x^12 + x^11 + x^3 + x^2 + x + 1                0x80F
CRC16           x^16 + x^15 + x^2 + 1                          0x8005 
CRC16-CCITT     x^16 + x^12 + x^5 + 1                          0x1021 
CRC32           x^32 + x^26 + x^23 + x^22 + x^16 + x^12 +      0x04C11DB7 
                x^11+ x^10 + x^8 + x^7 + x^5 + x^4 + 
                x^2 + x + 1 
*/

// 

module crc32 (
input                                clk                                ,
input                                rst_n                              ,
input            [7:0    ]           data_in                            ,
input                                data_in_valid                      ,
input                                crc_clr                            ,// 高电平清除
output   reg     [31:0   ]           crc32_out                       
);

reg              [31:0   ]           crc32_tmp                          ;
reg              [31:0   ]           data_crc32                         ;
reg                                  temp                               ;                


integer                              i                                  ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        data_crc32               <=0;
    end
    else begin
        if(crc_clr)begin
            data_crc32           <=32'b1111_1111_1111_1111_1111_1111_1111_1111; //0;
        end
        else begin
            if(data_in_valid)begin
                data_crc32       <=crc32_tmp;//crc16_tmp;
            end
        end
    end
end

//crc16
//初始化为0;
//输出值为crc16_tmp;
// always @(data_crc16 or data_in)begin
    // crc16_tmp = data_crc16;
    // for (i=7;i>=0;i=i-1)
    // begin
    // temp            = crc16_tmp[15] ^ data_in[i];
    // crc16_tmp[15]   = crc16_tmp[14]             ;
    // crc16_tmp[14]   = crc16_tmp[13]             ;    
    // crc16_tmp[13]   = crc16_tmp[12]             ;
    // crc16_tmp[12]   = crc16_tmp[11] ^ temp      ;
    // crc16_tmp[11]   = crc16_tmp[10]             ;
    // crc16_tmp[10]   = crc16_tmp[9]              ;
    // crc16_tmp[9]    = crc16_tmp[8]              ;
    // crc16_tmp[8]    = crc16_tmp[7]              ;
    // crc16_tmp[7]    = crc16_tmp[6]              ;
    // crc16_tmp[6]    = crc16_tmp[5]              ;
    // crc16_tmp[5]    = crc16_tmp[4]  ^ temp      ;
    // crc16_tmp[4]    = crc16_tmp[3]              ;
    // crc16_tmp[3]    = crc16_tmp[2]              ;
    // crc16_tmp[2]    = crc16_tmp[1]              ;
    // crc16_tmp[1]    = crc16_tmp[0]              ;
    // crc16_tmp[0]    = temp                      ;
    // end
// end

always @(*)begin
    crc32_tmp = data_crc32; 
    for (i=0;i<=7;i=i+1) begin
        temp            = crc32_tmp[31] ^ data_in[i];
        crc32_tmp[31]   = crc32_tmp[30]             ;
        crc32_tmp[30]   = crc32_tmp[29]             ;
        crc32_tmp[29]   = crc32_tmp[28]             ;
        crc32_tmp[28]   = crc32_tmp[27]             ;
        crc32_tmp[27]   = crc32_tmp[26]             ;
        crc32_tmp[26]   = crc32_tmp[25] ^ temp      ;
        crc32_tmp[25]   = crc32_tmp[24]             ;
        crc32_tmp[24]   = crc32_tmp[23]             ;
        crc32_tmp[23]   = crc32_tmp[22] ^ temp      ;
        crc32_tmp[22]   = crc32_tmp[21] ^ temp      ;
        crc32_tmp[21]   = crc32_tmp[20]             ;
        crc32_tmp[20]   = crc32_tmp[19]             ;
        crc32_tmp[19]   = crc32_tmp[18]             ;
        crc32_tmp[18]   = crc32_tmp[17]             ;
        crc32_tmp[17]   = crc32_tmp[16]             ;
        crc32_tmp[16]   = crc32_tmp[15] ^ temp      ;
        crc32_tmp[15]   = crc32_tmp[14]             ;
        crc32_tmp[14]   = crc32_tmp[13]             ;    
        crc32_tmp[13]   = crc32_tmp[12]             ;
        crc32_tmp[12]   = crc32_tmp[11] ^ temp      ;
        crc32_tmp[11]   = crc32_tmp[10] ^ temp      ;
        crc32_tmp[10]   = crc32_tmp[9]  ^ temp      ;
        crc32_tmp[9]    = crc32_tmp[8]              ;
        crc32_tmp[8]    = crc32_tmp[7]  ^ temp      ;
        crc32_tmp[7]    = crc32_tmp[6]  ^ temp      ;
        crc32_tmp[6]    = crc32_tmp[5]              ;
        crc32_tmp[5]    = crc32_tmp[4]  ^ temp      ;
        crc32_tmp[4]    = crc32_tmp[3]  ^ temp      ;
        crc32_tmp[3]    = crc32_tmp[2]              ;
        crc32_tmp[2]    = crc32_tmp[1]  ^ temp      ;
        crc32_tmp[1]    = crc32_tmp[0]  ^ temp      ;
        crc32_tmp[0]    = temp                      ;
    end
end

always @ (posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		crc32_out <= 0;
	end
	else if(data_in_valid)begin
		crc32_out[31] <= ~crc32_tmp[0]          ;
		crc32_out[30] <= ~crc32_tmp[1]          ;
		crc32_out[29] <= ~crc32_tmp[2]          ;
		crc32_out[28] <= ~crc32_tmp[3]          ;
		crc32_out[27] <= ~crc32_tmp[4]          ;
		crc32_out[26] <= ~crc32_tmp[5]          ;
		crc32_out[25] <= ~crc32_tmp[6]          ;
		crc32_out[24] <= ~crc32_tmp[7]          ;
                                                
		crc32_out[23] <= ~crc32_tmp[8]          ;
		crc32_out[22] <= ~crc32_tmp[9]          ;
		crc32_out[21] <= ~crc32_tmp[10]         ;
		crc32_out[20] <= ~crc32_tmp[11]         ;
		crc32_out[19] <= ~crc32_tmp[12]         ;
		crc32_out[18] <= ~crc32_tmp[13]         ;
		crc32_out[17] <= ~crc32_tmp[14]         ;
		crc32_out[16] <= ~crc32_tmp[15]         ;
                
		crc32_out[15] <= ~crc32_tmp[16]         ;
		crc32_out[14] <= ~crc32_tmp[17]         ;
		crc32_out[13] <= ~crc32_tmp[18]         ;
		crc32_out[12] <= ~crc32_tmp[19]         ;
		crc32_out[11] <= ~crc32_tmp[20]         ;
		crc32_out[10] <= ~crc32_tmp[21]         ;
		crc32_out[9]  <= ~crc32_tmp[22]         ;
		crc32_out[8]  <= ~crc32_tmp[23]         ;
                
		crc32_out[7]  <= ~crc32_tmp[24]         ;
		crc32_out[6]  <= ~crc32_tmp[25]         ;
		crc32_out[5]  <= ~crc32_tmp[26]         ;
		crc32_out[4]  <= ~crc32_tmp[27]         ;
		crc32_out[3]  <= ~crc32_tmp[28]         ;
		crc32_out[2]  <= ~crc32_tmp[29]         ;
		crc32_out[1]  <= ~crc32_tmp[30]         ;
		crc32_out[0]  <= ~crc32_tmp[31]         ;
	end
end
	
 endmodule