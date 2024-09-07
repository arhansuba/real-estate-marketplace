import React from 'react';
import mainimg from "../assets/skyscraper.jpg"

const HeroSection = () => {
  return (
    <section className="hero px-[10%] py-[10%]  bg-black">
      <div className="container md:mx-[10%] flex flex-col justify-center gap-x-5 md:flex-row items-center">

        <div className="hero-content  text-center md:text-left md:w-1/2">
          {/* Title */}
          <h1 className="text-6xl text-white font-bold mb-6">
            Invest in Tokenized <span>Real Estate</span> 
          </h1>

          {/* List */}
          <ul className="list-none space-y-1 text-gray-300 mb-6">
            <li><strong>🟡 1 Token = 1 Share</strong></li>
            <li><strong>🟡 Exchange your tokens on global exchanges</strong></li>
            <li><strong>🟡 +9% per year of yield</strong></li>
            <li><strong>🟡 Rents transferred in DAI to your wallet</strong></li>
            <li><strong>🟡 Low minimum ticket, start from $10</strong></li>
            
          </ul>

          {/* Buttons */}
          <div className="btn-group flex flex-col md:flex-row md:space-x-4 space-y-4 md:space-y-0">
            <button className="btn btn-primary w-[41%] bg-[yellow] border-2 border-black text-black py-4 px-4 rounded-lg hover:bg-transparent hover:border-[yellow] hover:text-white transition">
              Explore Properties
            </button>

            <button className="btn btn-secondary w-[41%] border-yellow-300 border-2 text-white py-2 px-4 rounded-lg hover:bg-yellow-950 transition">
              Explore Baskets
            </button>
          </div>
        </div>

        {/* Image */}
        <figure className="hero-banner md:w-1/2 mt-8 md:mt-0">
          <img src={mainimg} alt="nft art" className=" w-[70%] h-[70%] border-[20px] border-gray-900 rounded-[50%] shadow-lg" />
        </figure>

      </div>
    </section>
  );
}

export default HeroSection;
