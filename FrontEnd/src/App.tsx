import { WagmiConfig, createConfig } from "wagmi";
import { ConnectKitProvider, ConnectKitButton, getDefaultConfig } from "connectkit";
import { useState } from "react";

const config = createConfig(
  getDefaultConfig({
    // Required API Keys
    alchemyId: process.env.ALCHEMY_ID, // or infuraId
    walletConnectProjectId: "",

    // Required
    appName: "Your App Name",

    // Optional
    appDescription: "Your App Description",
    appUrl: "https://family.co", // your app's url
    appIcon: "https://family.co/logo.png", // your app's icon, no bigger than 1024x1024px (max. 1MB)
  }),
);

export const App = () => {

  //const [highScore, setHighScore] = useState(0);
  const [serverResponse, setServerResponse] = useState("");

  async function submitHighScore() {
    const currentHighScore = ((window as any)["Runner"])?.highestScore
    const response = await fetch('/express_backend');
    const body = await response.json();
    setServerResponse(body);
  }

  return (
    <div>
    <WagmiConfig config={config}>
      <ConnectKitProvider>
        <ConnectKitButton />
      </ConnectKitProvider>
    </WagmiConfig>
    <button onClick={submitHighScore}>Submit high score: {serverResponse}</button> 
    </div>
  );
};