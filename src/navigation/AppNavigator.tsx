import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import React from 'react';
import ProfileScreen from '../screens/ProfileScreen';
import UserIdScreen from '../screens/UserIdScreen';

export type RootTabParamList = {
  UserSettings: undefined;
  Profile: undefined;
};

import Ionicons from 'react-native-vector-icons/Ionicons';

const Tab = createBottomTabNavigator<RootTabParamList>();

const AppNavigator = () => {
  return (
    <Tab.Navigator
      initialRouteName="UserSettings"
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarActiveTintColor: '#3B82F6',
        tabBarInactiveTintColor: '#64748B',
        tabBarStyle: {
          backgroundColor: '#FFFFFF',
          borderTopColor: '#E2E8F0',
          height: 60,
          paddingBottom: 8,
          paddingTop: 8,
        },
        tabBarLabelStyle: {
          fontSize: 12,
          fontWeight: '600',
        },
        tabBarIcon: ({ focused, color, size }) => {
          let iconName = '';

          if (route.name === 'UserSettings') {
            iconName = focused ? 'settings' : 'settings-outline';
          } else if (route.name === 'Profile') {
            iconName = focused ? 'person' : 'person-outline';
          }

          return <Ionicons name={iconName} size={size} color={color} />;
        },
      })}
    >
      <Tab.Screen
        name="UserSettings"
        component={UserIdScreen}
        options={{ title: 'Configuration' }}
      />
      <Tab.Screen
        name="Profile"
        component={ProfileScreen}
        options={{ title: 'Mon Profil' }}
      />
    </Tab.Navigator>
  );
};

export default AppNavigator;

