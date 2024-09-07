import React from 'react';
import ProductCard from './Card';

const ProductCardList = ({ products }) => {
  return (
    <div className="flex flex-wrap gap-4 justify-center">
      {products.map((product, index) => (
        <ProductCard
          key={index}
          image={product.image}
          title={product.title}
          investment={product.investment}
          type={product.type}
        />
      ))}
    </div>
  );
};

export default ProductCardList;
