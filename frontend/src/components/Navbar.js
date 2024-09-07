import React, { useState } from 'react';
import logo from "../assets/skyscraper.jpg"

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);

  const toggleMenu = () => {
    setIsOpen(!isOpen);
  };

  return (
    <nav className="bg-black text-white p-4 md:px-[10%]">
      <div className="container mx-auto flex flex-wrap justify-between items-center">
        {/* Logo */}
        <div className="flex items-center space-x-4">
          <img src={logo} alt="Logo" className="w-[60px] h-[60px]" />
          
        </div>

        {/* Hamburger Menu Icon */}
        <div className="md:hidden">
          <button onClick={toggleMenu} className="focus:outline-none">
            <svg
              className="w-6 h-6 text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M4 6h16M4 12h16m-7 6h7"
              ></path>
            </svg>
          </button>
        </div>

        {/* Nav Links */}
        <div className={`w-full md:w-auto md:flex space-y-2 md:space-y-0 space-x-0 md:space-x-8 mt-4 md:mt-0 ${isOpen ? 'block' : 'hidden'} md:block`}>
          <a href="#" className="block hover:text-gray-400">Home</a>
          <a href="#" className="block hover:text-gray-400">About</a>
          <a href="#" className="block hover:text-gray-400">Explore</a>
          <a href="#" className="block hover:text-gray-400">Properties</a>
          <a href="#" className="block hover:text-gray-400">Basket</a>
          <a href="#" className="block hover:text-gray-400">Blog</a>
          <a href="#" className="block hover:text-gray-400">Contact</a>
        </div>

        {/* Search and Sign In */}
        <div className="w-full md:w-auto flex flex-wrap items-center space-y-2 md:space-y-0 space-x-0 md:space-x-4 mt-4 md:mt-0">
          <input 
            type="text" 
            placeholder="Search" 
            className="w-full md:w-auto bg-gray-800 text-white px-4 py-2 md:py-5 rounded-md focus:outline-none"
          />
          <button className="w-full md:w-auto bg-yellow-400 text-black px-4 py-2  rounded-md hover:bg-yellow-600">
            SIGN IN
          </button>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
