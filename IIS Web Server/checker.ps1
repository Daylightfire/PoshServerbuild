﻿Get-WindowsOptionalFeature -Online | ? {$_.FeatureName -like "*NET*"}| Format-Table -Property FeatureName, State