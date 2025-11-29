import { NavigationContainer, DefaultTheme } from '@react-navigation/native';
import React from 'react';
import { StatusBar, StyleSheet } from 'react-native';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import AppNavigator from './navigation/AppNavigator';
import { UserIdProvider } from './storage/UserIdContext';

const navigationTheme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    background: '#020617',
  },
};

const App = () => {
  return (
    <GestureHandlerRootView style={styles.root}>
      <SafeAreaProvider>
        <UserIdProvider>
          <NavigationContainer theme={navigationTheme}>
            <StatusBar barStyle="light-content" />
            <AppNavigator />
          </NavigationContainer>
        </UserIdProvider>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
};

const styles = StyleSheet.create({
  root: { flex: 1 },
});

export default App;
