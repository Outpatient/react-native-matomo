var Piwik = require('react-native').NativeModules.Piwik;
module.exports = {
  initTracker: Piwik.initTracker,
  setAppOptOut: function(isOptedOut) {
    Piwik.setAppOptOut(isOptedOut);
  },
  setUserId: function(userId) {
    if (userId !== null && userId !== userId !== undefined) {
      Piwik.setUserId(userId + '');
    }
  },
  trackAppDownload: Piwik.trackAppDownload,
  trackEvent: function(category, action, name, value) {
    Piwik.trackEvent(category, action, { name, value });
  },
  trackGoal: function(goalId, revenue) {
    Piwik.trackGoal(goalId, {revenue});
  },
  trackScreen: function(screen, title) {
    Piwik.trackScreen(screen, title);
  },
  trackCampaign: function (campaignName, campaignKeyword) {
    Piwik.trackCampaign(campaignName, campaignKeyword);
  }
};
