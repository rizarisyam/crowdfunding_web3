import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';
import { AuthProvider } from './use-auth-client';
import { RouterProvider, createBrowserRouter } from 'react-router-dom';
import CreateCampaign from './routes/campaigns/createCampaign';
import ListCampaign from './routes/campaigns/listCampaign';

const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    children: [
      {
        path: 'campaings',
        children: [
          {
            path: '',
            element: <ListCampaign />
          },
          {
            path: 'create',
            element: <CreateCampaign />
          }
        ]
      },
    ]
  },
  
])

ReactDOM.createRoot(document.getElementById('root')).render(
    <AuthProvider>
  <RouterProvider router={router}>
      {/* <App /> */}
  </RouterProvider>
    </AuthProvider>
);
