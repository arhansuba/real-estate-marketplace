import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faEllipsisH, faHeart } from '@fortawesome/free-solid-svg-icons';

const ProductCard = ({ image, title, investment, type }) => {
  return (
    <div className="bg-[#262626] p-5 rounded-lg shadow-lg w-[260px] border-thin border border-gray-600 group hover:cursor-pointer">
      <figure className="relative h-[230px]">
        <img
          src={image}
          alt={title}
          className="w-full h-[100%] object-cover rounded-lg"
        />

        <div className="absolute top-2 left-2 flex space-x-[120px]">
          <button className="bg-yellow-400 px-3 py-2 rounded-[50%]">
            <FontAwesomeIcon  icon={faEllipsisH} />
          </button>

          <button className="bg-gray-800 px-3 py-2 rounded-[50%]">
            <FontAwesomeIcon color="white" icon={faHeart} />
          </button>
        </div>

        {/* Hover effect for the "View Property" button */}
        <a
          href="property1.html"
          className="absolute bottom-[30%] left-[30%]  bg-yellow-400 text-black text-center py-3 w-[90px] rounded-lg opacity-0 group-hover:opacity-100 hover:-translate-y-3 transition-opacity duration-300"
        >
          View Property
        </a>
      </figure>

      <div className="mt-4 flex flex-col gap-y-1 text-gray-400">
        <a href="#" className="text-xl font-semibold block">
          {title}
        </a>

        <div className="flex flex-col mt-2">
          <div className="flex flex-row justify-between">
            <p className="text-gray-400">Min. Investment</p>
            <p className="text-lg font-medium">${investment}</p>
          </div>

          <div className='mt-3'>
            <p className="text-gray-400">{type}</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProductCard;
