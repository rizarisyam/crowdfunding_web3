import { useEffect, useState } from 'react';
import { crowdfunding_backend } from 'declarations/crowdfunding_backend';
import LoggedIn from './LoggendIn';
import LoggedOut from './LoggedOut';
import { AuthProvider, useAuth } from './use-auth-client';
import { Outlet } from 'react-router-dom';


function App() {
  const { isAuthenticated, identity } = useAuth();

  const [sessionData, setSessionData] = useState({})

  const [principalId, setPrincipalId] = useState("")
 
  useEffect(() => {
    console.log('effect running')
    // verifyConnection()
    // requestBalance()
  }, [])

  const onConnectPlugWallet = async () => {
    try {
      const publicKey = await window.ic.plug.requestConnect();
      console.log('connect', publicKey)
    } catch (error) {
      console.log('error', error)
    }
  }

  const verifyConnection = async () => {
    try {
      const connected = await window.ic.plug.isConnected();
      if (!connected) await window.ic.plug.requestConnect()
      if (connected) {
        setSessionData(window.ic.plug.sessionManager.sessionData)
        setPrincipalId(window.ic.plug.principalId)
        console.log('session data', principalId)
      }
    } catch (error) {

    }
  }

  const requestBalance = async () => {
    try {
      const result = await window.ic.plug.requestBalance()
      console.log('result', result)
    } catch (error) {
      console.log('error', error)
    }
  }
  return (
    <>
      {/* <header id="header">
        <section id="status" className="toast hidden">
          <span id="content" className='bg-red-500'>Hello</span>
          <button className="close-button" type="button">
            <svg
              aria-hidden="true"
              className="w-5 h-5"
              fill="currentColor"
              viewBox="0 0 20 20"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                fillRule="evenodd"
                d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                clipRule="evenodd"
              ></path>
            </svg>
          </button>
        </section>
      </header>
      <main id="pageContent">
        {isAuthenticated ? <LoggedIn /> : <LoggedOut />}
      </main> */}

      <div className="navbar bg-base-100">
        <div className="navbar-start">
          <div className="dropdown">
            <div tabIndex={0} role="button" className="btn btn-ghost btn-circle dark:text-base-content">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 6h16M4 12h16M4 18h7" /></svg>
            </div>
            <ul tabIndex={0} className="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52 dark:text-base-content">
              <li><a>Homepage</a></li>
              <li><a>Create campaing</a></li>
              <li><a>About</a></li>
            </ul>
          </div>
        </div>
        <div className="navbar-center">
          <a className="btn btn-ghost text-xl dark:text-base-content">daisyUI</a>
        </div>
        <div className="navbar-end">
        <button onClick={verifyConnection} className="btn btn-neutral w-fit dark:text-base-content">Connect Wallet</button>
        </div>
      </div>

      <main>
        <Outlet />
      </main>
    </>
  );
}

export default App;
