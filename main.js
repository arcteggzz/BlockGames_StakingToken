const serverUrl = "https://ujwb1som3llq.usemoralis.com:2053/server" 
const appId = "TPzse1a4T6YsxrbB5Em4weILu5cR0AUplKU43QsZ"
Moralis.start({ serverUrl, appId });



/* Authentication code */
async function login() {
    let user = Moralis.User.current();
    if (!user) {
        await Moralis.enableWeb3();
        user = await Moralis.authenticate({ signingMessage: "Log in using Moralis" })
        .then(function (user) {
            console.log("logged in user:", user);
            console.log(user.get("ethAddress"));
        })
        .catch(function (error) {
            console.log(error);
        });
    }
}
  
async function logOut() {
    await Moralis.User.logOut();
    console.log("logged out");
}



async function viewTotalTokensStaked(){
    const amountToStake = document.querySelector(".card input")
    if (amountToStake.value === 0){
        return
    } else {
        let options = {
            contractAddress: "0x7CfBAe35E66bc635Ba410E027a657cc426Cab58c",
            functionName: "createStake",
            abi:[{"inputs":[{"internalType":"uint256","name":"_stake","type":"uint256"}],"name":"createStake","outputs":[],"stateMutability":"nonpayable","type":"function"}],
            params:{
                _stake: amountToStake
            }
        };
        await Moralis.executeFunction(options)
    }    
}

async function StakeTokens(){
    const amountToStake = document.querySelector(".card input")
    if (amountToStake.value === 0){
        return
    } else {
        let options = {
            contractAddress: "0x7CfBAe35E66bc635Ba410E027a657cc426Cab58c",
            functionName: "createStake",
            abi:[{"inputs":[{"internalType":"uint256","name":"_stake","type":"uint256"}],"name":"createStake","outputs":[],"stateMutability":"nonpayable","type":"function"}],
            params:{
                _stake: amountToStake
            }
        };
        await Moralis.executeFunction(options)
    }    
}

document.getElementById("btn-login").onclick = login;
document.getElementById("btn-logout").onclick = logOut;

document.getElementById("btn-get-total-stake").onclick = viewTotalTokensStaked;
document.getElementById("btn-stake").onclick = StakeTokens;
document.getElementById("btn-get-total-balance").onclick = viewTotalTokensBalace;
document.getElementById("btn-transferTokens").onclick = transferTokens;



