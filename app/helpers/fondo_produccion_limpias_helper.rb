module FondoProduccionLimpiasHelper
    def format_rut_with_miles(rut)
        rut.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1.')
    end
end
