CONST_SIDE_BACKHAND = "CONST_SIDE_BACKHAND"
CONST_SIDE_FOREHAND = "CONST_SIDE_FOREHAND"

CONST_DIST_CLOSE = "CONST_DIST_CLOSE"
CONST_DIST_NORMAL = "CONST_DIST_NORMAL"
CONST_DIST_LUNGE = "CONST_DIST_LUNGE"
CONST_DIST_DIVE = "CONST_DIST_DIVE"

CONST_HIT_NORMAL = "CONST_HIT_NORMAL"
CONST_HIT_BACKSPIN = "CONST_HIT_BACKSPIN"
CONST_HIT_TOPSPIN = "CONST_HIT_TOPSPIN"

CONST_GND_DIST_LO = "CONST_GND_DIST_LO"
CONST_GND_DIST_MD = "CONST_GND_DIST_MD"
CONST_GND_DIST_HI = "CONST_GND_DIST_HI"

ANIM_HIT_DELAY = {
    CONST_DIST_CLOSE = 9 * 33,
    CONST_DIST_NORMAL = 8 * 33,
    CONST_DIST_DIVE = 13 * 33
}

ANIM_DIST_OFFSET = {
    [CONST_SIDE_BACKHAND] = {
        [CONST_DIST_CLOSE] = vector2(-0.3, 0.5),
        [CONST_DIST_NORMAL] = vector2(-0.8, 0.6),
        [CONST_DIST_DIVE] = vector2(-2.5, -0.15)
    },
    [CONST_SIDE_FOREHAND] = {
        [CONST_DIST_CLOSE] = vector2(0.3, 0.5),
        [CONST_DIST_NORMAL] = vector2(0.8, 0.6),
        [CONST_DIST_DIVE] = vector2(2.5, -0.15)
    }
}

ANIM_GND_DIST_OFFSET = {
    CONST_GND_DIST_LO = -0.5,
    CONST_GND_DIST_MD = -0.1,
    CONST_GND_DIST_HI = 0.3
}

ANIM_TREE = {
    [CONST_SIDE_BACKHAND] = {
        [CONST_DIST_CLOSE] = {
            [CONST_HIT_NORMAL] = {
                [CONST_GND_DIST_LO] = "close_bh_lo",
                [CONST_GND_DIST_MD] = "close_bh_md",
                [CONST_GND_DIST_HI] = "close_bh_hi"
            },
            [CONST_HIT_BACKSPIN] = {
                [CONST_GND_DIST_LO] = "close_bh_bs_lo",
                [CONST_GND_DIST_MD] = "close_bh_bs_md",
                [CONST_GND_DIST_HI] = "close_bh_bs_hi"
            },
            [CONST_HIT_TOPSPIN] = {
                [CONST_GND_DIST_LO] = "close_bh_ts_lo",
                [CONST_GND_DIST_MD] = "close_bh_ts_md",
                [CONST_GND_DIST_HI] = "close_bh_ts_hi"
            }
        },
        [CONST_DIST_NORMAL] = {
            [CONST_HIT_NORMAL] = {
                [CONST_GND_DIST_LO] = "backhand_bs_lo",
                [CONST_GND_DIST_MD] = "backhand",
                [CONST_GND_DIST_HI] = "backhand_ts_hi"
            },
            [CONST_HIT_BACKSPIN] = {
                [CONST_GND_DIST_LO] = "backhand_bs_lo",
                [CONST_GND_DIST_MD] = "backhand_bs_md",
                [CONST_GND_DIST_HI] = "backhand_bs_hi"
            },
            [CONST_HIT_TOPSPIN] = {
                [CONST_GND_DIST_LO] = "backhand_ts_lo",
                [CONST_GND_DIST_MD] = "backhand_ts_md",
                [CONST_GND_DIST_HI] = "backhand_ts_hi"
            }
        },
        [CONST_DIST_DIVE] = {
            [CONST_HIT_NORMAL] = {
                [CONST_GND_DIST_LO] = "dive_bh_short_lo",
                [CONST_GND_DIST_MD] = "dive_bh",
                [CONST_GND_DIST_HI] = "dive_bh_short_hi"
            },
            [CONST_HIT_BACKSPIN] = {
                [CONST_GND_DIST_LO] = "dive_bh_short_lo",
                [CONST_GND_DIST_MD] = "dive_bh",
                [CONST_GND_DIST_HI] = "dive_bh_short_hi"
            },
            [CONST_HIT_TOPSPIN] = {
                [CONST_GND_DIST_LO] = "dive_bh_short_lo",
                [CONST_GND_DIST_MD] = "dive_bh",
                [CONST_GND_DIST_HI] = "dive_bh_short_hi"
            }
        }
    },
    [CONST_SIDE_FOREHAND] = {
        [CONST_DIST_CLOSE] = {
            [CONST_HIT_NORMAL] = {
                [CONST_GND_DIST_LO] = "close_fh_lo",
                [CONST_GND_DIST_MD] = "close_fh_md",
                [CONST_GND_DIST_HI] = "close_fh_hi"
            },
            [CONST_HIT_BACKSPIN] = {
                [CONST_GND_DIST_LO] = "close_fh_bs_lo",
                [CONST_GND_DIST_MD] = "close_fh_bs_md",
                [CONST_GND_DIST_HI] = "close_fh_bs_hi"
            },
            [CONST_HIT_TOPSPIN] = {
                [CONST_GND_DIST_LO] = "close_fh_ts_lo",
                [CONST_GND_DIST_MD] = "close_fh_ts_md",
                [CONST_GND_DIST_HI] = "close_fh_ts_hi"
            }
        },
        [CONST_DIST_NORMAL] = {
            [CONST_HIT_NORMAL] = {
                [CONST_GND_DIST_LO] = "forehand_bs_lo",
                [CONST_GND_DIST_MD] = "forehand",
                [CONST_GND_DIST_HI] = "forehand_ts_hi"
            },
            [CONST_HIT_BACKSPIN] = {
                [CONST_GND_DIST_LO] = "forehand_bs_lo",
                [CONST_GND_DIST_MD] = "forehand_bs_md",
                [CONST_GND_DIST_HI] = "forehand_bs_hi"
            },
            [CONST_HIT_TOPSPIN] = {
                [CONST_GND_DIST_LO] = "forehand_ts_lo",
                [CONST_GND_DIST_MD] = "forehand_ts_md",
                [CONST_GND_DIST_HI] = "forehand_ts_hi"
            }
        },
        [CONST_DIST_DIVE] = {
            [CONST_HIT_NORMAL] = {
                [CONST_GND_DIST_LO] = "dive_fh_short_lo",
                [CONST_GND_DIST_MD] = "dive_fh",
                [CONST_GND_DIST_HI] = "dive_fh_short_hi"
            },
            [CONST_HIT_BACKSPIN] = {
                [CONST_GND_DIST_LO] = "dive_fh_short_lo",
                [CONST_GND_DIST_MD] = "dive_fh",
                [CONST_GND_DIST_HI] = "dive_fh_short_hi"
            },
            [CONST_HIT_TOPSPIN] = {
                [CONST_GND_DIST_LO] = "dive_fh_short_lo",
                [CONST_GND_DIST_MD] = "dive_fh",
                [CONST_GND_DIST_HI] = "dive_fh_short_hi"
            }
        }
    }
}
