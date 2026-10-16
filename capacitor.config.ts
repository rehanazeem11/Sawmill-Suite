import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.timberdoors.billing',
  appName: 'Timber & Door Billing',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  }
};

export default config;
