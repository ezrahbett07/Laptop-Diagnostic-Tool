# CPU Database - Verified specs for common laptop CPUs
# Format: Name | Cores | Threads | BaseClock | TDP | Architecture | Year | ExpectedL3Cache
$cpuDatabase = @(
    # AMD Ryzen 5000 Series (Zen 3)
    "AMD Ryzen 5 5600H|6|12|3300|45|Zen 3|2021|16"
    "AMD Ryzen 5 5600U|6|12|2300|15|Zen 3|2021|16"
    "AMD Ryzen 7 5800H|8|16|3200|45|Zen 3|2021|16"
    "AMD Ryzen 7 5800U|8|16|1900|15|Zen 3|2021|16"
    "AMD Ryzen 9 5900HX|8|16|3300|45|Zen 3|2021|16"
    
    # AMD Ryzen 6000 Series (Zen 3+)
    "AMD Ryzen 5 6600H|6|12|3300|45|Zen 3+|2022|16"
    "AMD Ryzen 7 6800H|8|16|3200|45|Zen 3+|2022|16"
    
    # AMD Ryzen 7000 Series (Zen 4)
    "AMD Ryzen 5 7535HS|6|12|3300|35|Zen 3+|2023|16"
    "AMD Ryzen 7 7735HS|8|16|3200|35|Zen 3+|2023|16"
    "AMD Ryzen 7 7840HS|8|16|3800|35|Zen 4|2023|16"
    "AMD Ryzen 9 7940HS|8|16|4000|35|Zen 4|2023|16"
    
    # AMD Ryzen PRO (Business)
    "AMD Ryzen 5 PRO 3500U|4|8|2100|15|Zen|2019|4"
    "AMD Ryzen 7 PRO 3700U|4|8|2300|15|Zen|2019|4"
    "AMD Ryzen 5 PRO 4650U|6|12|2100|15|Zen 2|2020|8"
    "AMD Ryzen 7 PRO 4750U|8|16|1700|15|Zen 2|2020|8"
    "AMD Ryzen 5 PRO 5650U|6|12|2100|15|Zen 3|2021|16"
    "AMD Ryzen 7 PRO 5850U|8|16|1900|15|Zen 3|2021|16"
    
    # AMD Athlon/Ryzen 3 (Budget)
    "AMD Ryzen 3 5300U|4|8|2600|15|Zen 2|2021|4"
    "AMD Ryzen 3 7320U|4|8|2400|15|Zen 2|2022|4"
    "AMD Athlon 3050U|2|4|2300|15|Zen|2020|4"
    
    # Intel 10th Gen
    "Intel(R) Core(TM) i5-10210U|4|8|1600|15|Comet Lake|2019|6"
    "Intel(R) Core(TM) i5-1035G1|4|8|1000|15|Ice Lake|2019|6"
    "Intel(R) Core(TM) i7-10510U|4|8|1800|15|Comet Lake|2019|8"
    "Intel(R) Core(TM) i7-10710U|6|12|1100|15|Comet Lake|2019|12"
    "Intel(R) Core(TM) i7-1065G7|4|8|1300|15|Ice Lake|2019|8"
    
    # Intel 11th Gen
    "Intel(R) Core(TM) i5-1135G7|4|8|2400|28|Tiger Lake|2020|8"
    "Intel(R) Core(TM) i5-1145G7|4|8|2600|28|Tiger Lake|2020|8"
    "Intel(R) Core(TM) i7-1165G7|4|8|2800|28|Tiger Lake|2020|12"
    "Intel(R) Core(TM) i7-1185G7|4|8|3000|28|Tiger Lake|2020|12"
    "Intel(R) Core(TM) i9-11900H|8|16|2500|45|Tiger Lake|2021|24"
    
    # Intel 12th Gen
    "Intel(R) Core(TM) i5-1235U|10|12|1300|15|Alder Lake|2022|12"
    "Intel(R) Core(TM) i5-1240P|12|16|1700|28|Alder Lake|2022|12"
    "Intel(R) Core(TM) i7-1255U|10|12|1700|15|Alder Lake|2022|12"
    "Intel(R) Core(TM) i7-12700H|14|20|2300|45|Alder Lake|2022|24"
    "Intel(R) Core(TM) i9-12900H|14|20|2500|45|Alder Lake|2022|24"
    
    # Intel 13th Gen
    "Intel(R) Core(TM) i5-1335U|10|12|1300|15|Raptor Lake|2023|12"
    "Intel(R) Core(TM) i7-1355U|10|12|1700|15|Raptor Lake|2023|12"
    "Intel(R) Core(TM) i7-13700H|14|20|2400|45|Raptor Lake|2023|24"
    "Intel(R) Core(TM) i9-13900H|14|20|2600|45|Raptor Lake|2023|24"
    
    # Intel 14th Gen
    "Intel(R) Core(TM) 5 210H|8|12|2200|45|Redwood Cove|2024|12"
    "Intel(R) Core(TM) 7 240H|8|16|2500|45|Redwood Cove|2024|24"
    "Intel(R) Core(TM) Ultra 5 125H|14|18|1700|28|Meteor Lake|2023|18"
    "Intel(R) Core(TM) Ultra 7 155H|16|22|1400|28|Meteor Lake|2023|24"
    "Intel(R) Core(TM) Ultra 9 185H|16|22|2300|45|Meteor Lake|2023|24"
    
    # Intel Core i (Generic names)
    "Intel(R) Core(TM) i5-8250U|4|8|1600|15|Kaby Lake|2017|6"
    "Intel(R) Core(TM) i5-8350U|4|8|1700|15|Kaby Lake|2017|6"
    "Intel(R) Core(TM) i7-8550U|4|8|1800|15|Kaby Lake|2017|8"
    "Intel(R) Core(TM) i7-8650U|4|8|1900|15|Kaby Lake|2017|8"
    "Intel(R) Core(TM) i5-7200U|2|4|2500|15|Kaby Lake|2016|3"
    "Intel(R) Core(TM) i7-7500U|2|4|2700|15|Kaby Lake|2016|4"
)

# Expected laptop model specs (common business laptops)
$laptopSpecs = @{
    # HP EliteBook series
    "HP EliteBook 745 G6" = @{
        ExpectedCPUFamily = "AMD Ryzen 5 PRO|Ryzen 7 PRO"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    "HP EliteBook 840 G6" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    "HP EliteBook 840 G7" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "HP EliteBook 840 G8" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "HP EliteBook 850 G6" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    
    # Dell Latitude series
    "Dell Latitude 5400" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    "Dell Latitude 5410" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 2666
    }
    "Dell Latitude 5420" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "Dell Latitude 5430" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 3200
    }
    "Dell Latitude 7490" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2018
        ExpectedMaxRAMSpeed = 2400
    }
    
    # ============================================================
    # LENOVO THINKPAD SERIES (Business)
    # ============================================================
    # ThinkPad X1 Carbon
    "ThinkPad X1 Carbon Gen 6" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2018
        ExpectedMaxRAMSpeed = 2400
    }
    "ThinkPad X1 Carbon Gen 7" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    "ThinkPad X1 Carbon Gen 8" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad X1 Carbon Gen 9" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 4266
    }
    "ThinkPad X1 Carbon Gen 10" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 5200
    }
    "ThinkPad X1 Carbon Gen 11" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2023
        ExpectedMaxRAMSpeed = 5600
    }
    "ThinkPad X1 Carbon Gen 12" = @{
        ExpectedCPUFamily = "Intel.*Ultra 5|Ultra 7"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 512
        ReleaseYear = 2024
        ExpectedMaxRAMSpeed = 7467
    }
    
    # ThinkPad X1 Yoga
    "ThinkPad X1 Yoga Gen 4" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    "ThinkPad X1 Yoga Gen 5" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad X1 Yoga Gen 6" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 4266
    }
    "ThinkPad X1 Yoga Gen 7" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 5200
    }
    
    # ThinkPad T Series
    "ThinkPad T14 Gen 1" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad T14 Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 48
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad T14 Gen 3" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 48
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad T14 Gen 4" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2023
        ExpectedMaxRAMSpeed = 5600
    }
    "ThinkPad T14s Gen 1" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad T14s Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad T14s Gen 3" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 5200
    }
    "ThinkPad T16 Gen 1" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 48
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad T16 Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 5200
    }
    "ThinkPad T480" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2018
        ExpectedMaxRAMSpeed = 2400
    }
    "ThinkPad T490" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 48
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    "ThinkPad T495" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    "ThinkPad T15 Gen 1" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 48
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad T15 Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 48
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    
    # ThinkPad L Series (Budget Business)
    "ThinkPad L14 Gen 1" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad L14 Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad L14 Gen 3" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad L15 Gen 1" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad L15 Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad L480" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 32
        ExpectedStorageType = "SSD|HDD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2018
        ExpectedMaxRAMSpeed = 2400
    }
    "ThinkPad L490" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    
    # ThinkPad E Series (Entry Business)
    "ThinkPad E14 Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen|Intel.*i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad E14 Gen 3" = @{
        ExpectedCPUFamily = "AMD Ryzen|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 40
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad E15 Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen|Intel.*i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad E15 Gen 3" = @{
        ExpectedCPUFamily = "AMD Ryzen|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 40
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 3200
    }
    
    # ThinkPad P Series (Workstation)
    "ThinkPad P14s Gen 1" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 48
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad P14s Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 48
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad P15v Gen 1" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    
    # ThinkPad X Series (Ultrabook)
    "ThinkPad X13 Gen 1" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad X13 Gen 2" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkPad X13 Gen 3" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 5200
    }
    "ThinkPad X390" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    
    # ThinkPad Z Series (Modern)
    "ThinkPad Z13 Gen 1" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 6400
    }
    "ThinkPad Z16 Gen 1" = @{
        ExpectedCPUFamily = "AMD Ryzen PRO"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 6400
    }
    
    # ============================================================
    # LENOVO THINKBOOK SERIES (SMB)
    # ============================================================
    "ThinkBook 13s Gen 2" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkBook 13s Gen 3" = @{
        ExpectedCPUFamily = "AMD Ryzen|Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkBook 14 G2 ITL" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 40
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkBook 14 G3 ACL" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 40
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkBook 14 G4+ ABA" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 40
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkBook 15 G2 ITL" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 40
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkBook 15 G3 ACL" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 40
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkBook 16 G2 IAH" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 64
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 3200
    }
    "ThinkBook 16p G2 ACH" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 512
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 4800
    }
    
    # ============================================================
    # LENOVO IDEAPAD SERIES (Consumer)
    # ============================================================
    "IdeaPad 3 14ITL6" = @{
        ExpectedCPUFamily = "Intel.*i3|i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe|SSD|HDD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "IdeaPad 3 15ITL6" = @{
        ExpectedCPUFamily = "Intel.*i3|i5|i7"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe|SSD|HDD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "IdeaPad 3 14ALC6" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 4
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe|SSD"
        ExpectedStorageMinGB = 128
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "IdeaPad 5 14ITL05" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "IdeaPad 5 15ITL05" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "IdeaPad 5 14ALC05" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "IdeaPad 5 Pro 14ITL6" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "IdeaPad 5 Pro 16ACH6" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "IdeaPad Flex 5 14ITL05" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "IdeaPad Flex 5 14ALC05" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    
    # ============================================================
    # LENOVO YOGA SERIES (Premium Consumer)
    # ============================================================
    "Yoga 7 14ITL5" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "Yoga 7 14ARB7" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 3200
    }
    "Yoga 7i 14ITL5" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "Yoga 9 14ITL5" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 4266
    }
    "Yoga 9i 14ITL5" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 4266
    }
    "Yoga Slim 7 14ITL05" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "Yoga Slim 7 14ARE05" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    
    # ============================================================
    # LENOVO LEGION SERIES (Gaming)
    # ============================================================
    "Legion 5 15IMH05" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3200
    }
    "Legion 5 15ACH5" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "Legion 5 Pro 16ACH6" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 512
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "Legion 5i 16ITH6" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 512
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "Legion 7 16ACHg6" = @{
        ExpectedCPUFamily = "AMD Ryzen"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 512
        ReleaseYear = 2021
        ExpectedMaxRAMSpeed = 3200
    }
    "Legion Slim 7 16IAH7" = @{
        ExpectedCPUFamily = "Intel.*i5|i7"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 32
        ExpectedStorageType = "NVMe"
        ExpectedStorageMinGB = 512
        ReleaseYear = 2022
        ExpectedMaxRAMSpeed = 4800
    }
    
    # ============================================================
    # APPLE MACBOOK (via Boot Camp/VM - rare)
    # ============================================================
    "MacBookPro15,1" = @{
        ExpectedCPUFamily = "Intel.*i7|i9"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 64
        ExpectedStorageType = "SSD"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2400
    }
    "MacBookPro16,1" = @{
        ExpectedCPUFamily = "Intel.*i7|i9"
        ExpectedRAMMin = 16
        ExpectedRAMMax = 64
        ExpectedStorageType = "SSD"
        ExpectedStorageMinGB = 512
        ReleaseYear = 2019
        ExpectedMaxRAMSpeed = 2666
    }
    "MacBookAir9,1" = @{
        ExpectedCPUFamily = "Intel.*i3|i5|i7"
        ExpectedRAMMin = 8
        ExpectedRAMMax = 16
        ExpectedStorageType = "SSD"
        ExpectedStorageMinGB = 256
        ReleaseYear = 2020
        ExpectedMaxRAMSpeed = 3733
    }
}

# Storage verification database
$storageDatabase = @{
    # Common NVMe SSDs found in business laptops
    "Micron MTFDHBA256TDV" = @{ Type="NVMe"; CapacityGB=256; Interface="NVMe"; Health="Good" }
    "Micron MTFDHBA512TDV" = @{ Type="NVMe"; CapacityGB=512; Interface="NVMe"; Health="Good" }
    "Micron MTFDKBA512QFM" = @{ Type="NVMe"; CapacityGB=512; Interface="NVMe"; Health="Good" }
    "SK hynix BC501 HFM256GDJTNG" = @{ Type="NVMe"; CapacityGB=256; Interface="NVMe"; Health="Good" }
    "SK hynix BC711 HFM512GDJTNG" = @{ Type="NVMe"; CapacityGB=512; Interface="NVMe"; Health="Good" }
    "SK hynix BC901 HFS512GJ9TND" = @{ Type="NVMe"; CapacityGB=512; Interface="NVMe"; Health="Good" }
    "Samsung PM981a MZVLB256HAHQ" = @{ Type="NVMe"; CapacityGB=256; Interface="NVMe"; Health="Excellent" }
    "Samsung PM991a MZVLQ256HBJD" = @{ Type="NVMe"; CapacityGB=256; Interface="NVMe"; Health="Good" }
    "Samsung PM9B1 MZVL4256HBJU" = @{ Type="NVMe"; CapacityGB=256; Interface="NVMe"; Health="Excellent" }
    "Samsung PM9C1a MZVL4512HBLU" = @{ Type="NVMe"; CapacityGB=512; Interface="NVMe"; Health="Excellent" }
    "WDC PC SN520 SDAPNUW" = @{ Type="NVMe"; CapacityGB=256; Interface="NVMe"; Health="Good" }
    "WDC PC SN530 SDBNPNZ" = @{ Type="NVMe"; CapacityGB=256; Interface="NVMe"; Health="Good" }
    "WDC PC SN740 SDDPNQD" = @{ Type="NVMe"; CapacityGB=256; Interface="NVMe"; Health="Excellent" }
    "Intel SSD PEKNV080G8" = @{ Type="NVMe"; CapacityGB=80; Interface="NVMe"; Health="Good" }
    "Intel SSD PEKKF512G8" = @{ Type="NVMe"; CapacityGB=512; Interface="NVMe"; Health="Good" }
    "Kingston OM8PDP3256B" = @{ Type="NVMe"; CapacityGB=256; Interface="NVMe"; Health="Good" }
    "Crucial P2 CT250P2SSD8" = @{ Type="NVMe"; CapacityGB=250; Interface="NVMe"; Health="Good" }
    "Crucial P5 CT500P5SSD8" = @{ Type="NVMe"; CapacityGB=500; Interface="NVMe"; Health="Excellent" }
}

# RAM verification
$ramDatabase = @{
    # Common laptop RAM modules
    "HMA81GS6MFR8N-UH" = @{ Type="DDR4"; Speed=2400; CapacityGB=8; Manufacturer="SK Hynix" }
    "HMA81GS6AFR8N-UH" = @{ Type="DDR4"; Speed=2400; CapacityGB=8; Manufacturer="SK Hynix" }
    "HMAA1GS6CJR6N-XN" = @{ Type="DDR4"; Speed=2400; CapacityGB=8; Manufacturer="SK Hynix" }
    "8ATF1G64HZ-3G2E1" = @{ Type="DDR4"; Speed=3200; CapacityGB=16; Manufacturer="ADATA" }
    "M471A1K43CB1-CRC" = @{ Type="DDR4"; Speed=3200; CapacityGB=8; Manufacturer="Samsung" }
    "M471A1G44AB0-CWE" = @{ Type="DDR4"; Speed=3200; CapacityGB=8; Manufacturer="Samsung" }
    "CT8G4SFRA32A.C8FH" = @{ Type="DDR4"; Speed=3200; CapacityGB=8; Manufacturer="Crucial" }
    "CT16G4SFRA32A.C16F" = @{ Type="DDR4"; Speed=3200; CapacityGB=16; Manufacturer="Crucial" }
    "KSA3200LLS8/8" = @{ Type="DDR4"; Speed=3200; CapacityGB=8; Manufacturer="Kingston" }
}

function Verify-CPU {
    param(
        [string]$cpuName,
        [int]$cores,
        [int]$threads,
        [int]$clockSpeed,
        [int]$l3Cache
    )
    
    $result = @{
        Found = $false
        ExpectedCores = 0
        ExpectedThreads = 0
        ExpectedClock = 0
        ExpectedCache = 0
        Architecture = ""
        Year = 0
        MatchType = "Unknown"
        Warnings = @()
    }
    
    foreach ($entry in $cpuDatabase) {
        $parts = $entry -split '\|'
        $dbName = $parts[0]
        
        # Check if CPU name matches database entry
        if ($cpuName -match [regex]::Escape($dbName) -or $dbName -match [regex]::Escape($cpuName)) {
            $result.Found = $true
            $result.ExpectedCores = [int]$parts[1]
            $result.ExpectedThreads = [int]$parts[2]
            $result.ExpectedClock = [int]$parts[3]
            $result.ExpectedCache = [int]$parts[7]
            $result.Architecture = $parts[5]
            $result.Year = [int]$parts[6]
            $result.MatchType = "Exact"
            
            # Verify cores
            if ($cores -ne $result.ExpectedCores) {
                $result.Warnings += "CPU Cores mismatch: Found $cores, Expected $($result.ExpectedCores)"
            }
            
            # Verify threads
            if ($threads -ne $result.ExpectedThreads) {
                $result.Warnings += "CPU Threads mismatch: Found $threads, Expected $($result.ExpectedThreads)"
            }
            
            # Verify clock speed (allow 10% tolerance)
            if ($result.ExpectedClock -gt 0) {
                $clockDiff = [math]::Abs($clockSpeed - $result.ExpectedClock) / $result.ExpectedClock
                if ($clockDiff -gt 0.1) {
                    $result.Warnings += "Clock speed unusual: Found ${clockSpeed}MHz, Expected $($result.ExpectedClock)MHz"
                }
            }
            
            # Verify cache
            if ($result.ExpectedCache -gt 0 -and $l3Cache -gt 0) {
                if ($l3Cache -lt ($result.ExpectedCache * 0.8)) {
                    $result.Warnings += "L3 Cache low: Found ${l3Cache}KB, Expected $($result.ExpectedCache)KB"
                }
            }
            
            break
        }
    }
    
    # Partial match if exact not found
    if (-not $result.Found) {
        # Try partial match on key terms
        $searchTerms = @()
        if ($cpuName -match "Ryzen\s+(\d+)\s+PRO\s+(\d+)") {
            $searchTerms += "Ryzen $($matches[1]) PRO $($matches[2])"
        }
        elseif ($cpuName -match "Ryzen\s+(\d+)\s+(\d{4})") {
            $searchTerms += "Ryzen $($matches[1]) $($matches[2])"
        }
        elseif ($cpuName -match "Core\(TM\)\s+(i\d-\d{4,5}[A-Z]*)") {
            $searchTerms += $matches[1]
        }
        
        foreach ($term in $searchTerms) {
            foreach ($entry in $cpuDatabase) {
                if ($entry -match [regex]::Escape($term)) {
                    $parts = $entry -split '\|'
                    $result.Found = $true
                    $result.ExpectedCores = [int]$parts[1]
                    $result.ExpectedThreads = [int]$parts[2]
                    $result.ExpectedClock = [int]$parts[3]
                    $result.ExpectedCache = [int]$parts[7]
                    $result.Architecture = $parts[5]
                    $result.Year = [int]$parts[6]
                    $result.MatchType = "Partial"
                    
                    if ($cores -ne $result.ExpectedCores) {
                        $result.Warnings += "CPU Cores mismatch: Found $cores, Expected $($result.ExpectedCores)"
                    }
                    if ($threads -ne $result.ExpectedThreads) {
                        $result.Warnings += "CPU Threads mismatch: Found $threads, Expected $($result.ExpectedThreads)"
                    }
                    break
                }
            }
            if ($result.Found) { break }
        }
    }
    
    return $result
}

function Verify-LaptopModel {
    param(
        [string]$model,
        [string]$cpuName,
        [int]$ramGB,
        [string]$storageType,
        [int]$storageGB,
        [int]$ramSpeed
    )
    
    $result = @{
        Found = $false
        ExpectedRAMMin = 0
        ExpectedRAMMax = 0
        ExpectedStorageMinGB = 0
        ExpectedStorageType = ""
        ExpectedCPUFamily = ""
        ReleaseYear = 0
        Warnings = @()
        Recommendations = @()
    }
    
    foreach ($key in $laptopSpecs.Keys) {
        if ($model -match [regex]::Escape($key) -or $key -match [regex]::Escape($model)) {
            $spec = $laptopSpecs[$key]
            $result.Found = $true
            $result.ExpectedRAMMin = $spec.ExpectedRAMMin
            $result.ExpectedRAMMax = $spec.ExpectedRAMMax
            $result.ExpectedStorageMinGB = $spec.ExpectedStorageMinGB
            $result.ExpectedStorageType = $spec.ExpectedStorageType
            $result.ExpectedCPUFamily = $spec.ExpectedCPUFamily
            $result.ReleaseYear = $spec.ReleaseYear
            
            # Check RAM
            if ($ramGB -lt $spec.ExpectedRAMMin) {
                $result.Warnings += "RAM below minimum: ${ramGB}GB (Min: $($spec.ExpectedRAMMin)GB)"
            }
            if ($ramGB -gt $spec.ExpectedRAMMax) {
                $result.Warnings += "RAM exceeds max: ${ramGB}GB (Max: $($spec.ExpectedRAMMax)GB)"
            }
            
            # Check storage
            if ($storageGB -lt $spec.ExpectedStorageMinGB) {
                $result.Warnings += "Storage below minimum: ${storageGB}GB (Min: $($spec.ExpectedStorageMinGB)GB)"
            }
            if ($storageType -notmatch $spec.ExpectedStorageType) {
                $result.Warnings += "Storage type unexpected: $storageType (Expected: $($spec.ExpectedStorageType))"
            }
            
            # Check CPU family
            if ($cpuName -notmatch $spec.ExpectedCPUFamily) {
                $result.Warnings += "CPU may not be original: $cpuName (Expected: $($spec.ExpectedCPUFamily))"
                $result.Recommendations += "CPU may have been replaced - verify with seller"
            }
            
            # Check RAM speed
            if ($ramSpeed -gt 0 -and $spec.ExpectedMaxRAMSpeed -gt 0 -and $ramSpeed -gt $spec.ExpectedMaxRAMSpeed) {
                $result.Warnings += "RAM speed exceeds original spec: ${ramSpeed}MHz (Max: $($spec.ExpectedMaxRAMSpeed)MHz)"
            }
            
            # Age recommendation
            $age = (Get-Date).Year - $spec.ReleaseYear
            if ($age -gt 5) {
                $result.Recommendations += "Laptop is $age years old - battery may be degraded"
            }
            if ($age -gt 7) {
                $result.Recommendations += "Consider if $age years is acceptable for your needs"
            }
            
            break
        }
    }
    
    return $result
}

function Verify-Storage {
    param(
        [string]$modelName,
        [long]$sizeBytes,
        [string]$busType
    )
    
    $result = @{
        Found = $false
        ExpectedType = ""
        ExpectedCapacityGB = 0
        Health = "Unknown"
        Warnings = @()
    }
    
    $sizeGB = [math]::Round($sizeBytes / 1GB, 0)
    
    foreach ($key in $storageDatabase.Keys) {
        if ($modelName -match [regex]::Escape($key) -or $key -match [regex]::Escape($modelName)) {
            $spec = $storageDatabase[$key]
            $result.Found = $true
            $result.ExpectedType = $spec.Type
            $result.ExpectedCapacityGB = $spec.CapacityGB
            $result.Health = $spec.Health
            
            # Check capacity
            $capDiff = [math]::Abs($sizeGB - $spec.CapacityGB) / $spec.CapacityGB
            if ($capDiff -gt 0.1) {
                $result.Warnings += "Storage capacity mismatch: Found ${sizeGB}GB, Expected $($spec.CapacityGB)GB"
            }
            
            break
        }
    }
    
    # Check interface
    if ($busType -eq "NVMe" -and $sizeGB -ge 256) {
        # Good
    }
    elseif ($busType -eq "SATA" -and $sizeGB -ge 256) {
        $result.Warnings += "SATA SSD is slower than NVMe - consider if acceptable"
    }
    elseif ($busType -eq "SCSI") {
        $result.Warnings += "SCSI interface detected - verify actual bus type"
    }
    
    return $result
}

function Verify-RAM {
    param(
        [string]$partNumber,
        [int]$capacityGB,
        [int]$speed,
        [string]$manufacturer
    )
    
    $result = @{
        Found = $false
        ExpectedType = ""
        ExpectedSpeed = 0
        ExpectedCapacityGB = 0
        Warnings = @()
        Info = @()
    }
    
    # Clean part number
    $cleanPart = $partNumber.Trim()
    
    foreach ($key in $ramDatabase.Keys) {
        if ($cleanPart -match [regex]::Escape($key) -or $key -match [regex]::Escape($cleanPart)) {
            $spec = $ramDatabase[$key]
            $result.Found = $true
            $result.ExpectedType = $spec.Type
            $result.ExpectedSpeed = $spec.Speed
            $result.ExpectedCapacityGB = $spec.CapacityGB
            
            if ($speed -ne $spec.Speed) {
                $result.Info += "RAM running at ${speed}MHz (Module rated: $($spec.Speed)MHz)"
            }
            if ($capacityGB -ne $spec.CapacityGB) {
                $result.Warnings += "RAM capacity mismatch: Found ${capacityGB}GB, Module: $($spec.CapacityGB)GB"
            }
            
            break
        }
    }
    
    # General RAM checks
    if ($speed -lt 2400) {
        $result.Warnings += "RAM speed below DDR4 standard (2400MHz minimum)"
    }
    if ($capacityGB -lt 4) {
        $result.Warnings += "RAM below minimum for Windows 11 (4GB)"
    }
    if ($capacityGB -eq 4) {
        $result.Warnings += "4GB RAM is minimum - consider 8GB+ for smooth performance"
    }
    
    return $result
}
