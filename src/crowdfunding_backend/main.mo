import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import WhoAmI "WhoAmI";

actor {

  // Return the principal identifier of the wallet canister that installed this
  // canister.
  public shared (install) func installer() : async Principal {
    return install.caller;
  };

  // Return the principal identifier that was provided as an installation
  // argument to this canister.
  public query func argument(someone : Principal) : async Principal {
    return someone;
  };

  // Return the principal identifier of the caller of this method.
  public shared query (msg) func whoami() : async Principal {
    msg.caller;
  };

  // Return the principal identifier of this canister.
  public func id() : async Principal {
    return await whoami();
  };

  // // Return the principal identifier of this canister via the optional `this` binding.
  // // This is much quicker than `id()` above, since it avoids the latency of `await whoami()`.
  // public func idQuick() : async Principal {
  //   return Principal.fromActor(this);
  // };

  type Campaign = {
    id : Nat;
    name : Text;
    goal : Nat;
    balance : Nat;
    owner : Text;
    donationsCount : Nat;
    deadline : Int;
    description : Text;
    isNotFinished : Bool;
    imageURL : Text;
    raised : Nat;
  };

  type Donation = {
    amount : Nat;
    donor : Nat;
  };

  type Transaction = {
    amount : Nat;
    recipient : Nat;
    description : Text;
  };

  private type PayloadCreateCampaign = {
    owner: Text;
    name: Text;
    description: Text;
    goal: Nat;
    deadline: Int;
  };

  let campaigns = Buffer.Buffer<Campaign>(10);

  public shared ({caller}) func createCampaign(payload: PayloadCreateCampaign) : async Nat {
    let campaign : Campaign = {
      id = 1;
      name = payload.name;
      goal = payload.goal;
      balance = 1;
      owner = payload.owner;
      donationsCount = 1;
      deadline = payload.deadline;
      description = payload.description;
      isNotFinished = true;
      imageURL = "Text";
      raised = 1;
    };
    campaigns.add(campaign);
    return campaign.id;
  };

  public query func getCampaigns() : async [Campaign] {
    return Buffer.toArray<Campaign>(campaigns);
  };

  public query func getCampaign(index : Nat) : async Campaign {
    return campaigns.get(index);
  };

};
