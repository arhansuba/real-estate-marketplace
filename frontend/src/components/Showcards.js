import React from 'react';
import ProductCardList from './Productcardlist';
import image1 from '../assets/plot1.jpeg'
import image2 from '../assets/plot2.jpg'
import image3 from '../assets/plot3.jpeg'
import image4 from '../assets/plot4.jpg'

const products = [
  {
    image: image1,
    title: "Dimond riding a blue body art",
    investment: 50,
    type: "Luxury Estate"
  },
  {
    image: image2,
    title: "Dimond riding a blue body art",
    investment: 500,
    type: "Urban Estate"
  },
  {
    image: image3,
    title: "Dimond riding a blue body art",
    investment: 30,
    type: "Rural Estate"
  },
  {
    image: image4,
    title: "Dimond riding a blue body art",
    investment: 90,
    type: "Industrial Estate"
  },
  
];

const ShowCard = () => {
  return (
    <div className="p-8 h-[100vh]  bg-[#121212]">
      <h1 className='text-white  mx-[5%] md:mx-[14%] text-xl md:text-4xl font-bold my-12'>Explore Properties</h1>
      <ProductCardList products={products} />
    </div>
  );
};

export default ShowCard;
