import { useEffect, useState } from 'react'
import { crowdfunding_backend as canister } from '../../../../declarations/crowdfunding_backend'
import { useNavigate } from 'react-router-dom';

export default function CreateCampaign() {

    const navigate = useNavigate();

    const [title, setTitle] = useState("")
    const [story, setStory] = useState("")
    const [goal, setGoal] = useState(0)
    const [endDate, setEndDate] = useState("")

    useEffect(() => {
        fetchCampaings()
    }, [])

    const fetchCampaings = async () => {
        const campaings = await canister.getCampaigns()
        console.log('campaings', campaings)
    }

    const onSubmit = async () => {
        const result = await window.ic.plug.isConnected()
        console.log('result', result)
        if (result) {
            const { principalId } = window.ic.plug.sessionManager.sessionData
            const payload = {
                owner: principalId,
                name: title,
                description: story,
                goal: +goal,
                deadline: new Date(endDate).getTime()
            }
            console.log('session data', principalId)
            console.log('payload', payload)
            const campaignResult = await canister.createCampaign(payload)
            if (campaignResult > 0) navigate('/campaings')
        }
    }

    return (
        <div className="card w-auto bg-base-100 shadow-xl">

            <div className="card-body">
                <h2 className="card-title dark:text-base-content">Create Campaign</h2>

                <label className="form-control w-full max-w-xs">
                    <div className="label">
                        <span className="label-text">Campaign Title*</span>

                    </div>
                    <input onChange={(e) => setTitle(e.target.value)} type="text" placeholder="Name of campaign" className="input input-bordered w-full max-w-xs dark:text-base-content" />
                    <div className="label">
                        <span className="label-text-alt">Bottom Left label</span>

                    </div>
                </label>

                <label className="form-control">
                    <div className="label">
                        <span className="label-text">Story*</span>

                    </div>
                    <textarea onChange={(e) => setStory(e.target.value)} className="textarea textarea-bordered h-24 dark:text-base-content" placeholder="Write your story"></textarea>
                    <div className="label">
                        <span className="label-text-alt">Your bio</span>

                    </div>
                </label>

                <div className="flex justify-between gap-x-2">
                    <label className="form-control w-full max-w-xs">
                        <div className="label">
                            <span className="label-text">Goal*</span>

                        </div>
                        <input onChange={(e) => setGoal(e.target.value)} type="text" placeholder="" className="input input-bordered w-full max-w-xs dark:text-base-content" />
                        <div className="label">
                            <span className="label-text-alt">Bottom Left label</span>

                        </div>
                    </label>
                    <label className="form-control w-full max-w-xs">
                        <div className="label">
                            <span className="label-text ">End Date*</span>

                        </div>
                        <input onChange={(e) => setEndDate(e.target.value)} type="date" className="input input-bordered w-full max-w-xs dark:text-base-content" />
                        <div className="label">
                            <span className="label-text-alt">Bottom Left label</span>

                        </div>
                    </label>
                </div>
                <div className="card-actions justify-end">
                    <button onClick={onSubmit} className="btn btn-primary">Buy Now</button>
                </div>
            </div>
        </div>
    )
}