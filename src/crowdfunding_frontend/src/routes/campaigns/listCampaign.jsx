import { useEffect, useState } from 'react'
import { crowdfunding_backend as canister } from '../../../../declarations/crowdfunding_backend'
export default function ListCampaign() {

    const [campaings, setCampaings] = useState([])
    const [errorMessage, setErrorMessage] = useState("")

    useEffect(() => {
        fetchCampaings()
        onRequestBalance()
    }, [])

    const fetchCampaings = async () => {
        try {
            const campaigns = await canister.getCampaigns()
            console.log('campaings list', campaigns)
            setCampaings(campaigns)
        } catch (error) {
            console.log('error', error)
        }

    }

    const onRequestBalance = async () => {
        try {
            const balance = await window.ic.plug.requestBalance()
            console.log('balance', balance)
        } catch (error) {
            console.error(error)
        }
    }

    const onRequestTransfer = async () => {
        try {
            const result = await window.ic.plug.isConnected()
            console.log('result', result)
            if (result) {
                const { principalId } = window.ic.plug.sessionManager.sessionData
                const params = {
                    to: principalId,
                    amount: 1000
                }
                const result = await window.ic.plug.requestTransfer(params)
                console.log('result', result)
            }
        } catch (error) {
            console.error(error)
            setErrorMessage(error)
        }

    }

    return (
        <>
            <div className='w-full grid grid-cols-4 gap-2 px-4'>
                {campaings.length && (
                    campaings.map((res, key) => (
                        <div key={key} className="card card-compact bg-base-100 shadow-xl">
                            <figure><img src="https://daisyui.com/images/stock/photo-1606107557195-0e29a4b5b4aa.jpg" alt="Shoes" /></figure>
                            <div className="card-body">
                                <h2 className="card-title dark:text-base-content">{res.name}</h2>
                                <p className='dark:text-base-content'>{res.description}</p>
                                <div className="card-actions justify-end">
                                    <button onClick={onRequestTransfer} className="btn btn-primary">Donate</button>
                                </div>
                            </div>
                        </div>
                    ))
                )}
            </div>

            {errorMessage.length && (
                <div className="toast toast-end">
                    <div className="alert alert-error">
                        <span>{errorMessage}</span>
                    </div>

                </div>
            )}
        </>
    )
}