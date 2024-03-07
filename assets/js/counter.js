const counter = document.querySelector(".counter-number");
async function updateCounter(){
    let response = await fetch("https://pz76by3uljfhsfy4zsiul7gcr40tnmou.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = `Views: ${data}`;
}

updateCounter();