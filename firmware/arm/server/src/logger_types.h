/* -------------------------------------------------------------------------------
 *
 * types.h
 *
 * (c) 2015 - 2016
 *  L. Schrittwieser
 *  N. Huesser
 *
 * -------------------------------------------------------------------------------
 *
 * This header contains all the required types to interface with the kernel module
 *
 * ---------------------------------------------------------------------------- */

enum err_codes {
    ERR_NONE,
    ERR_OUT_OF_BOUNDS_MEMORY,
    ERR_READ_ONLY,
    ERR_INVALID_NUM_CHANNELS,
    ERR_INVALID_REG,
    ERR_INVALID_INSTRUCTION,
    ERR_INVALID_CHANNEL,
    ERR_OUT_OF_BOUNDS_SLOT,
    ERR_WORKING
};

struct reg_instruction {
    uint8_t error_code;
    uint8_t reg_id;
    uint32_t reg_value;
};

struct trg_instruction {
    uint8_t error_code;
    uint16_t trg_id;
    uint16_t trg_slot_id;
    uint8_t trg_option;
    uint32_t trg_value;
};

struct err_instruction {
    uint8_t error_code;
};

struct data_instruction {
    uint8_t error_code;
    uint8_t channel;
    uint16_t resolution;
};