PetVariation = {
    ["A_C_Husky"] = {
        ["dark"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        },
        ["brown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 1
        },
        ["white"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 2
        }
    },
    ["A_C_Westy"] = {
        ["white"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 0
        },
        ["brown"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 1
        },
        ["dark"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 2
        }
    },
    ["A_C_shepherd"] = {
        ["darkBrown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        },
        ["white"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 1
        },
        ["brown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 2
        }
    },
    ["A_C_Rottweiler"] = {
        ["dark"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 0
        },
        ["brown"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 1
        },
        ["darkBrown"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 2
        }
    },
    ["A_C_Retriever"] = {
        ["brown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        },
        ["dark"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 1
        },
        ["white"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 2
        },
        ["darkBrown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 3
        }
    },
    ["A_C_Pug"] = {
        ["white"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 0
        },
        ["gray"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 1
        },
        ["brown"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 2
        },
        ["dark"] = {
            componentId = 4,
            drawableId = 0,
            textureId = 3
        }
    },
    ["A_C_Poodle"] = {
        ["white"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        }
    },
    ["A_C_MtLion"] = {
        ["white"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        },
        ["brown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 1
        },
        ["darkBrown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 2
        }
    },
    ["A_C_Panther"] = {
        ["dark"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        }
    },
    ["A_C_Cat_01"] = {
        ["gray"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        },
        ["dark"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 1
        },
        ["brown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 2
        }
    },
    ["A_C_Coyote"] = {
        ["gray"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        },
        ["lightGray"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 1
        },
        ["brown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 2
        },
        ["lightBrown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 3
        },
        ["darkBrown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 3
        }
    },
    ["A_C_Hen"] = {
        ["brown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        }
    },
    ["A_C_Rabbit_01"] = {
        ["brown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 0
        },
        ["DarkBrown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 1
        },
        ["LightBrown"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 2
        },
        ["gray"] = {
            componentId = 0,
            drawableId = 0,
            textureId = 3
        }
    }
}

function PetVariation:setPedVariation(pedHnadle, pedModel, variation)
    local data = PetVariation[pedModel]
    local data2 = {}
    if data ~= nil then
        data2 = PetVariation[pedModel][variation]
        if
            data2 ~= nil and
                IsPedComponentVariationValid(pedHnadle, data2.componentId, data2.drawableId, data2.textureId)
         then
            SetPedComponentVariation(pedHnadle, data2.componentId, data2.drawableId, data2.textureId)
            return true
        else
            return false
        end
    end
end

function PetVariation:getRandomPedVariationsName(pedModel, justVariation)
    if justVariation ~= nil and justVariation == true then
        local tmp = {}
        for key, value in pairs(PetVariation[pedModel]) do
            tmp[#tmp + 1] = key
        end
        return tmp[math.random(1, #tmp)]
    end
end

function VariationTester(ped, componentId)
    local drawableId = GetNumberOfPedDrawableVariations(ped, componentId)
    for drawableIndex = 0, drawableId - 1, 1 do
        local textureId = GetNumberOfPedTextureVariations(ped, componentId, drawableIndex)
        print("count(textureId): ", textureId)
        for textureIndex = 0, textureId - 1, 1 do
            print(
                "drawableindex: ",
                drawableIndex,
                "textureIndex: ",
                textureIndex,
                "valid: ",
                IsPedComponentVariationValid(ped, componentId, drawableIndex, textureIndex)
            )
        end
    end
end
