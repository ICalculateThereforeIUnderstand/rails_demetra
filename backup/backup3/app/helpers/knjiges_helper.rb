module KnjigesHelper
    def output(var)
        if var.nil?
            return "-";
        end
        if var == ''
            return "-";
        end
        if var == ' '
            return "-";
        end
        return var
    end
    def outputCijena(var)
        if var.nil?
            return "?kn";
        end
        if var == ''
            return "?kn";
        end
        return var.to_s + "kn"
    end
end