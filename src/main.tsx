
import { createRoot } from "react-dom/client";
import App from "./app/App.tsx";
import "./styles/index.css";

const GTM_ID = "GTM-N9XX5XB2";

type GTMWindow = Window & {
  dataLayer?: Array<Record<string, unknown>>;
};

function loadGoogleTagManager() {
  if (document.querySelector(`script[data-gtm-id="${GTM_ID}"]`)) {
    return;
  }

  const gtmWindow = window as GTMWindow;
  gtmWindow.dataLayer = gtmWindow.dataLayer || [];
  gtmWindow.dataLayer.push({
    "gtm.start": Date.now(),
    event: "gtm.js",
  });

  const script = document.createElement("script");
  script.async = true;
  script.dataset.gtmId = GTM_ID;
  script.src = `https://www.googletagmanager.com/gtm.js?id=${GTM_ID}`;
  document.head.appendChild(script);
}

if (typeof window !== "undefined") {
  window.addEventListener("load", loadGoogleTagManager, { once: true });
}

createRoot(document.getElementById("root")!).render(<App />);
  
