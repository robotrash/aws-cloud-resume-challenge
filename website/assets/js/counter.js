const counter = document.querySelector(".counter-number");
async function updateCounter(){
    let response = await fetch("https://5zi62uomfvu76o5x37kazqsuvu0ctoij.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = `Views: ${data}`;
}

updateCounter();