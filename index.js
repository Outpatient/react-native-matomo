// var Matomo;
var Matomo = require('react-native').NativeModules.Matomo;
import {Platform} from 'react-native'
module.exports = {
  initTracker: function(url, id) {
    if (!Matomo) return false;
    Matomo.initTracker(url, id);
    return true;
  },
  // initTracker: Matomo.initTracker,
  setUserId: function(userId) {
    if (userId !== null && userId !== userId !== undefined) {
      Matomo && Matomo.setUserId(userId + '');
    }
  },
  // trackAppDownload: Matomo.trackAppDownload,
  trackAppDownload: function() {
    Matomo && Matomo.trackAppDownload();
  },
  trackScreen: function(path, title) {
    Matomo && Matomo.trackScreen(path, title);
  },
  trackGoal: function(goalId, revenue) {
    Matomo && Matomo.trackGoal(goalId, {revenue});
  },
  trackEvent: function(category, action, name, value, url) {
    Matomo && Matomo.trackEvent(category, action, {name, value, url});
  },
  trackCampaign: function(name, keyword) {
    Matomo && Matomo.trackCampaign(name, keyword);
  },
  trackContentImpression: function(name, piece, target) {
    Matomo && Matomo.trackContentImpression(name, {piece, target});
  },
  trackContentInteraction: function(name, interaction, piece, target) {
    Matomo && Matomo.trackContentInteraction(name, {interaction, piece, target});
  },
  trackSearch: function(query, category, resultCount, url) {
    Matomo && Matomo.trackSearch(query, {category, resultCount, url});
  },
  trackVersion: function(version) {
    if (Platform.OS === 'ios') {
      Matomo && Matomo.set(version, 1);
    } else {
      Matomo && Matomo.setVersion(version);
    }
  },
  trackUserType: function(userType) {
    if (Platform.OS === 'ios') {
      Matomo && Matomo.set(userType, 2);
    } else {
      Matomo && Matomo.setUserType(userType);
    }
  }
};
