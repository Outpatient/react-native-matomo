var Matomo = require('react-native').NativeModules.Matomo;
import {Platform} from 'react-native'
module.exports = {
  initTracker: Matomo.initTracker,
  setUserId: function(userId) {
    if (userId !== null && userId !== userId !== undefined) {
      Matomo.setUserId(userId + '');
    }
  },
  trackAppDownload: Matomo.trackAppDownload,
  trackScreen: function(path, title) {
    Matomo.trackScreen(path, title);
  },
  trackGoal: function(goalId, revenue) {
    Matomo.trackGoal(goalId, {revenue});
  },
  trackEvent: function(category, action, name, value, url) {
    Matomo.trackEvent(category, action, {name, value, url});
  },
  trackCampaign: function(name, keyword) {
    Matomo.trackCampaign(name, keyword);
  },
  trackContentImpression: function(name, piece, target) {
    Matomo.trackContentImpression(name, {piece, target});
  },
  trackContentInteraction: function(name, interaction, piece, target) {
    Matomo.trackContentInteraction(name, {interaction, piece, target});
  },
  trackSearch: function(query, category, resultCount, url) {
    Matomo.trackSearch(query, {category, resultCount, url});
  },
  trackVersion: function(version) {
    if (Platform.OS === 'ios') {
      Matomo.set(version, 1);
    } else {
      Matomo.setVersion(version);
    }
  },
  trackUserType: function(userType) {
    if (Platform.OS === 'ios') {
      Matomo.set(userType, 2);
    } else {
      Matomo.setUserType(userType);
    }
  }
};
