-- rks precision: the game writes the RKS with 2 decimals (its "F2"), this writes it again with 3 right after

local UE = CS.UnityEngine

local function precise(text, rks)
  text.text = ("%.3f"):format(rks)
  text.horizontalOverflow = 1 -- Overflow: the label was sized for 2 decimals, the third must not wrap
end

hook(CS.PlayerBarControl, "GetRankingScoreInPlayerBar", { after = function(self) precise(self.rank, rks()) end })
hook(CS.StatsFrameController, "Start", { after = function(self) precise(self.rks, rks()) end })
hook(CS.CloudSaveInfoDisplay, "SetInfo", {
  after = function(self, summary) precise(self.rks, summary.RankingScore) end,
})

-- installed while the player's bar shows, it would keep 2 decimals until the next screen
on("load", function()
  local bar = UE.Object.FindObjectOfType(CS.PlayerBarControl)
  if bar then precise(bar.rank, rks()) end
end)
